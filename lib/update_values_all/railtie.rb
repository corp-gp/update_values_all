# frozen_string_literal: true

require 'update_values_all/batch_update'

module UpdateValuesAll
  class Railtie < ::Rails::Railtie

    initializer 'update_values_all.initialize' do
      ActiveSupport.on_load(:active_record) { extend UpdateValuesAll::BatchUpdate }
    end

  end
end
