class Customers < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'customers' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/store_users/authenticate.json?authentication_token=AXSSSSED2ASDASD1
    # curl -d '{"authentication_token": "CXTTTTED2ASDBSD4", "email": "gavs@lt.co.za", "password": "12345"}' 'http://localhost:9000/api/v1/customers/authenticate' -H Content-Type:application/json -v
    # curl -X POST -d '{"user":{"first_name": "poes"}}' -H "Accept: application/json" -H "Content-Type:application/json" http://localhost:9000/api/v1/customers/update?authentication_token=1b032cb31ad1f41e662238182ebbf456 -v
   
    desc "Updates a customer"
    post '/update' do
      authenticated_user
      logger.info "Updating customer with Username: #{current_user.email}"

      user = current_user 
      user_data = params[:user]

      UpdateCustomerContext.call(user, user_data) 
    end

    desc "Rests a pim for a customer"
    params do
      requires :id, :type => Integer, :desc => "Product id."
      requires :pin, :type => Integer, :desc => "Old Pin"
    end
    post '/:id/reset_pin' do
      authenticated_user
      logger.info "Resetting pin for customer with Username: #{current_user.email}"

      user = User.find(params[:id])  
      user_data = params[:user]

      if current_user.id == user.id
        ResetCustomerPinContext.call(user, user_data) 
      else
        error!({ "error" => "authentication error", "detail" => "current user does not have rights to edit thsi customer" }, 400)
      end
    end

    desc "Authenticates a Customer"
    params do
      requires :email, :type => String, :desc => "Email to authenticate."
      requires :password, :type => String, :desc => "Password to authenticate."
    end
    post '/authenticate' do
      authenticated_user
      logger.info "Authenticating Customer with Username: #{params[:email]}"

      customer = User.by_email(params[:email]).first      
      if customer.nil?
        error!({ "error" => "authentication error", "detail" => "customer with username \"#{params[:email]}\" not found" }, 400)
      else
        customer = AuthenticateCustomerContext.call(customer, params[:password])
        if customer
          customer
        else
          error!({ "error" => "authentication error", "detail" =>  "customer password does not match" }, 400)  
        end
      end
    end
  end


  
end