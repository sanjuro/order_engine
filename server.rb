require 'rubygems'
require 'bundler/setup'
require 'goliath'
require 'em-synchrony/activerecord'
require 'grape'
require 'acts_as_list'
require 'state_machine'
require 'kaminari/grape'
require 'geocoder'
require 'pusher'
require 'paperclip'

require File.dirname(__FILE__) + '/database_configuration.rb'
require File.dirname(__FILE__) + '/action_mailer_configuration.rb'
require File.dirname(__FILE__) + '/solr_configuration.rb'

Dir[File.dirname(__FILE__) + '/lib/notification_adapters/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/models/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/contexts/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/roles/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/apis/*.rb'].each {|file| require file }
Dir[File.dirname(__FILE__) + '/app/mailers/*.rb'].each {|file| require file }

class API < Grape::API
	
	prefix 'api'

	use ApiErrorHandler
	# use ApiPageHelper


	helpers do
	    def logger
	        # API.logger
	        logger = Logger.new(File.dirname(__FILE__) + '/log/vosto_order.log')
			logger.level = Logger::INFO
			logger
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

	mount Customers

	mount Devices

	mount Favourites

	mount Orders

	mount Products

	mount Stores

	mount StoreUsers

	mount Taxons

	mount Users

    resource :systems do
      desc "Describes API."
      get :describe_api do
      	  logger.info "Describes API"
		  api_hash = {}
		  api_hash['version'] = 1
		  api_hash['routes'] = API::routes
		  api_hash
      end
    end

end

class APIServer < Goliath::API
  # use Goliath::Rack::Params
  # use Goliath::Rack::JSONP

  def call(env)
    API.call(env)
  end
      
end