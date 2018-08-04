# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'factory_bot'
require 'factory_bot_rails/generator'
require 'rails'

module FactoryBot
  class Railtie < Rails::Railtie

    initializer "factory_bot.set_fixture_replacement" do
      FactoryBotRails::Generator.new(config).run
    end

    initializer "factory_bot.set_factory_paths" do
      FactoryBot.definition_file_paths = [
        Rails.root.join('factories'),
        Rails.root.join('test', 'factories'),
        Rails.root.join('spec', 'factories')
      ]
    end

    config.after_initialize do
      # This line is the one that fixes it:
      ActiveSupport.on_load(:active_record) { FactoryBot.find_definitions }

      if defined?(Spring)
        Spring.after_fork { FactoryBot.reload }
      end
    end
  end
end

require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'support/api_request_helpers'

require 'devise'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each { |f| require f }


ActiveRecord::Migration.maintain_test_schema!

ActiveJob::Base.queue_adapter = :test

Capybara.configure do |config|
  config.default_max_wait_time = 5
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    # Choose a test framework:
    with.test_framework :rspec
    with.library :rails
  end
end

RspecApiDocumentation.configure do |config|
  config.format = :json
end

RSpec.configure do |config|
  config.include(Shoulda::Callback::Matchers::ActiveModel)
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new(app,
    browser: :chrome,
    args: ["--window-size=1280,1024"]
    )
end

Capybara.javascript_driver = :selenium_chrome

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.include FactoryBot::Syntax::Methods
  config.include Rails.application.routes.url_helpers
  config.include Devise::Test::ControllerHelpers, :type => :controller
  config.include ApiRequests::AuthenticationHelpers
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
  config.use_transactional_fixtures = false

  config.before(:suite) do
    if config.use_transactional_fixtures?
      raise(<<-MSG)
        Delete line `config.use_transactional_fixtures = true` from rails_helper.rb
        (or set it to false) to prevent uncommitted transactions being used in
        JavaScript-dependent specs.

        During testing, the app-under-test that the browser driver connects to
        uses a different database connection to the database connection used by
        the spec. The app's database connection would not be able to access
        uncommitted transaction data setup over the spec's database connection.
      MSG
    end
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, type: :feature) do
    driver_shares_db_connection_with_specs = Capybara.current_driver == :rack_test

    if !driver_shares_db_connection_with_specs
      DatabaseCleaner.strategy = :truncation
    end
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
  #database cleaner config for capybara --ends
end
