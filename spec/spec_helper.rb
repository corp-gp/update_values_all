# frozen_string_literal: true

require 'bundler'
require 'logger'
require 'rails'
require 'dotenv/rails-now'
require 'dotenv/load'

Bundler.require :default, :development

Combustion.initialize! :active_record

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
