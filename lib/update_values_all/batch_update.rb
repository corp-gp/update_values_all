# frozen_string_literal: true

require "update_values_all/adapters/postgres"

module UpdateValuesAll
  module BatchUpdate

    def self.extended(klass)
      if defined?(::PG::Connection)
        klass.extend(UpdateValuesAll::Adapters::Postgres)
      end
    end

    def update_values_all(data, **keyword_args)
      return [] if data.empty?

      keyword_args[:key_to_match] ||= primary_key

      if defined?(::PG::Connection) && connection.raw_connection.is_a?(::PG::Connection)
        pg_update_values_all(data, **keyword_args)
      end
    end

  end
end
