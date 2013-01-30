class Users < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'users' do

    # curl -i -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD3","user":{"first_name":"Customer", "last_name":"Test","email":"customer@gmail.com","mobile_number":"0833908314","birthday":"1981-12-04","user_pin":"1234"}}' http://localhost:9000/api/v1/users/create_customer

    desc "Retrieve all User"
    get "/" do
      authenticated_user
      logger.info "Retrieved all users"
      User.all
    end
    
    desc "Retrieve a specific User"
    get "/:id" do 
      User.find(params['id'])
    end
    
    desc "Creates a new user of type customer"
    # params do
    #   requires :id, :type => Integer, :desc => "Product id."
    # end
    post '/create_customer' do
      authenticated_user
      logger.info "Creating new customer"
      SignupCustomerContext.call(params)
    end

    desc "Authenticates a Store User"
    params do
      requires :username, :type => String, :desc => "Username to authenticate."
      requires :password, :type => String, :desc => "Password to authenticate."
    end
    post '/authenticate_store' do
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