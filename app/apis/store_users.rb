class StoreUsers < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'store_users' do

    # curl -i -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD3","username":"sanjuro","password":"rad6hia"}' http://localhost:9000/api/v1/store_users/authenticate
    
    desc "Authenticates a Store User"
    params do
      requires :username, :type => String, :desc => "Username to authenticate."
      requires :password, :type => String, :desc => "Password to authenticate."
    end
    post '/authenticate' do
      authenticated_user
      logger.info "Authenticating new InStore Device with Username: #{params[:username]}"

      store_user = StoreUser.by_username(params[:username]).first
      if store_user.nil?

      else
        AuthenticateStoreContext.call(store_user, params[:password])
      end
    end
  end
  
end