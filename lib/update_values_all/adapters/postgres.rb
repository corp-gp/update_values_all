# frozen_string_literal: true

module UpdateValuesAll
  module Adapters
    module Postgres

      def pg_update_values_all(data, key_to_match:, touch: false, sql_update_expression: "updated_at = CURRENT_TIMESTAMP")
        keys = data.first.keys
        key_to_match = Array.wrap(key_to_match)

        sql_values = +''
        data.each do |hash_row|
          hash_keys = []
          serialize_row =
            hash_row.map do |column_name, value|
              hash_keys << column_name
              column_type = type_for_attribute(column_name)
              connection.quote(column_type.serialize(value))
            end

          raise KeyError, "Wrong keys: #{(hash_keys - keys) | (keys - hash_keys)}" if hash_keys != keys

          sql_values << "(#{serialize_row.join(', ')}),"
        end
        sql_values.chop!

        updated_keys = keys.join(", ")

        sql_types = data[0].keys.index_with { |column_name| column_for_attribute(column_name).sql_type_metadata.sql_type }
        set_expr  =
          if block_given?
            +yield
          else
            (keys - key_to_match)
              .map { |key| "#{key} = updated_data.#{key}::#{sql_types[key]}" }
              .join(", ")
          end
        only_changed_expr =
          if touch
            "TRUE"
          else
            (keys - key_to_match)
              .map { |key| "#{table_name}.#{key} IS DISTINCT FROM updated_data.#{key}::#{sql_types[key]}" }
              .join(" OR ")
          end

        if sql_update_expression.present?
          set_expr << ", #{sql_update_expression}"
        end

        existing_data_sql =
          select(primary_keys_sql(key_to_match, table_name)) # rubocop:disable Gp/PotentialSqlInjection
            .where("(#{primary_keys_sql(key_to_match, table_name)}) IN (SELECT #{primary_keys_sql(key_to_match, 'updated_data')} FROM updated_data)")
            .to_sql

        changed_ids =
          connection.query(<<~SQL) # rubocop:disable Gp/PotentialSqlInjection
            WITH
              updated_data(#{updated_keys}) AS (
                VALUES #{sql_values}
              ),
              existing_data AS (
                #{existing_data_sql}
              )
            UPDATE #{table_name}
            SET #{set_expr}
            FROM updated_data JOIN existing_data ON (#{primary_keys_sql(key_to_match, 'existing_data')}) = (#{primary_keys_sql(key_to_match, 'updated_data')})
            WHERE
                  (#{primary_keys_sql(key_to_match, 'updated_data')}) = (#{primary_keys_sql(key_to_match, table_name)})
              AND (#{primary_keys_sql(key_to_match, table_name)}) = (#{primary_keys_sql(key_to_match, 'existing_data')})
              AND (#{only_changed_expr})
            RETURNING #{primary_keys_sql(key_to_match, table_name)}
          SQL

        connection.query_cache.clear if connection.query_cache_enabled

        # When the primary key is composite (multi-column), we return an array of arrays
        key_to_match.size == 1 ? changed_ids.flatten : changed_ids
      end

      private def primary_keys_sql(keys, table_name)
        keys.map { |key| "#{table_name}.#{key}" }.join(", ")
      end
    end
  end
end
