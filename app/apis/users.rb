class Users < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'users' do

    # curl -i -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD4","user":{"first_name":"TEstee", "last_name":"Test","email":"shad6ster@gmail.com","mobile_number":"0833908314","user_pin":"11111"}}' http://127.0.0.1:9000/api/v1/users/create_customer

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

      # validate customer is unique
      customer = User.by_email(params[:user][:email]).first     

      if customer.nil?
        SignupCustomerContext.call(params)
      else
        error!({ "error" => "customer error", "detail" =>  "customer with email #{params[:user][:email]} already exists on the vosto system" }, 400)  
      end

    end

  end
  
end