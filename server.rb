require "rubygems"
require "bundler/setup"
require 'goliath'
require 'em-synchrony/activerecord'
require 'grape'
require 'acts_as_list'
require 'state_machine'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/apis/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/contexts/*.rb'].each {|file| require file }

require File.dirname(__FILE__) + '/database_configuration.rb'

class API < Grape::API
	
	prefix 'api'

	mount Orders

	mount Users

end

class APIServer < Goliath::API

  def call(env)
    API.call(env)
  end
      
end