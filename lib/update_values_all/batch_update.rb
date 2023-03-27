# frozen_string_literal: true

module UpdateValuesAll
  module BatchUpdate

    def self.extended(active_record_base)
      active_record_base.define_singleton_method(:inherited) do |subclass|
        super(subclass)

        case subclass.connection.raw_connection
        when ::PG::Connection
          subclass.extend UpdateValuesAll::Adapters::Postgres
        end
      end
    end

  end
end
