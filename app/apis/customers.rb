class Customers < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'customers' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/store_users/authenticate.json?authentication_token=AXSSSSED2ASDASD1
    # curl -d '{"authentication_token": "CXTTTTED2ASDBSD4", "email": "shad6ster@gmail.com", "pin": "41401"}' 'http://localhost:9000/api/v1/customers/authenticate' -H Content-Type:application/json -v
    # curl -X POST -d '{"user":{"first_name": "Jack"}}' -H "Accept: application/json" -H "Content-Type:application/json" http://localhost:9000/api/v1/customers/update?authentication_token=1b032cb31ad1f41e662238182ebbf456 -v
    # curl -X POST -d '{"email": "shadley@vosto.co.za", "pin": "21234"}' -H "Accept: application/json" http://107.22.211.58:9000/api/v1/customers/authenticate?authentication_token=CXTTTTED2ASDBSD3 -v
   
    desc "Updates a customer"
    post '/update' do
      authenticated_user
      logger.info "Updating customer with Username: #{current_user.email}"

      user = current_user 
      user_data = params[:user]

      UpdateCustomerContext.call(user, user_data) 
    end

    desc "Rests a pin for a customer"
    params do
      requires :email, :type => String, :desc => "Email to authenticate."
    end
    post '/reset_pin' do
      authenticated_user
      logger.info "Reseting pin for customer with Username: #{current_user.email}"

      customer = User.by_email(params[:email]).first     
      if customer.nil?
        error!({ "error" => "authentication error", "detail" => "customer with username \"#{params[:email]}\" not found" }, 400)
      else
        customer = ResetCustomerPinContext.call(customer)
        if customer
          customer
        else
          error!({ "error" => "authentication error", "detail" =>  "customer does not exist on the vosto system" }, 400)  
        end
      end
 
    end

    desc "Authenticates a Customer"
    params do
      requires :email, :type => String, :desc => "Email to authenticate."
      requires :pin, :type => String, :desc => "Pin to authenticate."
    end
    post '/authenticate' do
      authenticated_user
      logger.info "Authenticating Customer with Username: #{params[:email]}"

      customer = User.by_email(params[:email]).first     
      if customer.nil?
        error!({ "error" => "authentication error", "detail" => "customer with username \"#{params[:email]}\" not found" }, 400)
      else
        customer = AuthenticateCustomerContext.call(customer, params[:pin])
        if customer
          customer
        else
          error!({ "error" => "authentication error", "detail" =>  "customer password/pin does not match" }, 400)  
        end
      end
    end
  end


  
end