require 'spork'
require 'rack/test'
require 'factory_girl'
require './server'

FactoryGirl.find_definitions

Spork.prefork do 
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  
  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[File.dirname(__FILE__) + "spec/support/**/*.rb"].each {|file| require file }
  
  RSpec.configure do |config|

    # Use color in STDOUT
    config.color_enabled = true

    # Use color not only in STDOUT but also in pagers and files
    config.tty = true

    # Use the specified formatter
    config.formatter = :documentation # :progress, :html, :textmate
    
    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec
  
    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "/spec/fixtures"
  
    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = true
    
    # config.include Devise::TestHelpers, :type => :controller
    
    # config.extend ControllerMacros, :type => :controller
  end
end

Spork.each_run do 
end