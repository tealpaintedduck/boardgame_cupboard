# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)

Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rails'
require 'capybara/poltergeist'
include Capybara::Angular::DSL
Capybara.javascript_driver = :poltergeist
require 'support/database_cleaner'
require 'factory_girl_rails'
require_relative './support/app_helpers.rb'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  config.use_transactional_fixtures = false
  config.include FactoryGirl::Syntax::Methods

  config.infer_spec_type_from_file_location!
end