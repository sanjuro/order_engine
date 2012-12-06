require 'rubygems'
require 'bundler/setup'
require 'goliath'
require 'em-synchrony/activerecord'
require 'grape'
require 'acts_as_list'
require 'state_machine'
# require 'acts_as_tenant'

Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/contexts/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/roles/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/apis/*.rb'].each {|file| require file }

require File.dirname(__FILE__) + '/database_configuration.rb'

class API < Grape::API
	
	prefix 'api'

	use ApiErrorHandler

	helpers do
	    def logger
	      API.logger
	    end

	    def warden
	      env['warden']
	    end

	    def authenticated
	      if params[:authentication_token] and
	          user = User.find_for_token_authentication(params[:authentication_token])
	        return true
	      elsif params[:xapp_token] and
	          AccessGrant.find_access(params[:xapp_token])
	        return true
	      else
	        error!('401 Unauthorized', 401)
	      end
	    end

	    def current_user
	      User.find_for_token_authentication(params[:authentication_token])
	    end

	    def is_admin?
	      current_user && current_user.is_admin?
	    end

	    # returns 401 if there's no current user
	    def authenticated_user
	    	authenticated
	    	error!('401 Unauthorized', 401) unless current_user
	    end
	    
	    # returns 401 if not authenticated as admin
	    def authenticated_admin
	      authenticated
	      error!('401 Unauthorized', 401) unless is_admin?
	    end
	end

	mount Favourites

	mount Orders

	mount Products

	mount Stores

	mount Taxons

	mount Users

end

class APIServer < Goliath::API

  def call(env)
    API.call(env)
  end
      
end