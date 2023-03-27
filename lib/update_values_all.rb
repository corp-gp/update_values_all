# frozen_string_literal: true

require_relative 'update_values_all/version'
require_relative 'update_values_all/railtie'

module UpdateValuesAll

  autoload :BatchUpdate, 'update_values_all/batch_update'

  module Adapters

    autoload :Postgres, 'update_values_all/adapters/postgres'

  end

end
