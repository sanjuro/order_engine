class Customers < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'customers' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/store_users/authenticate.json?authentication_token=AXSSSSED2ASDASD1
    # curl -d '{"authentication_token": "CXTTTTED2ASDBSD3", "email": "shadley@vosto.co.za", "pin": "12204"}' 'http://107.22.211.58:9000/api/v1/customers/authenticate' -H Content-Type:application/json -v
    # curl -d '{"authentication_token": "CXTTTTED2ASDBSD3", "email": "shadley@vosto.co.za"}' 'http://127.0.0.1:9000/api/v1/customers/reset_pin' -H Content-Type:application/json -v
    # curl -X POST -d '{"user":{"first_name": "Shadley", "last_name": "Wentzel", "email": "shad6ster@gmail.com", "mobile_number":"0828688222", "user_pin":"11111"}}' -H "Accept: application/json" -H "Content-Type:application/json" http://localhost:9000/api/v1/customers/update?authentication_token=AXSSSSED2ASDASD1 -v
    # curl -X POST -d '{"email": "gavin@liquidthought.co.za", "pin": "21421"}' -H "Accept: application/json" http://107.22.211.58:9000/api/v1/customers/authenticate?authentication_token=CXTTTTED2ASDBSD3 -v
    # curl -X POST -d '{ "user": { "email": "shad6ster@gmail.com", "full_name": "Shad Man"} }' -H "Accept: application/json" http://107.22.211.58:9000/api/v1/customers/update?authentication_token=b5a27178456753ba773d83666d276631 -v 
    # curl -i -X POST -d '{"authentication_token": "b228b017e445b55b368c9608546a1ea1","payment_method_data": {"payment_method": "2","hash_value": "123fqf33t","unique_identifier": "b228b017e445b55b368c9608546a1ea1","device_identifier":"103edb7d8c4e3669"}}' http://127.0.0.1:9000/api/v1/customers/add_payment_profile -v
   
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
      logger.info "Reseting pin for customer"
      customer = User.by_email(params[:email]).first     
      if customer.nil?
        logger.info "Reseting pin for customer with Username: #{customer.email}"
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

    desc "Add payment profile for Customer"
    params do
      requires :authentication_token, :type => String, :desc => "Authentication Token"
    end
    post '/add_payment_profile' do
      authenticated_user
      logger.info "Authenticating Customer with Username: #{params[:email]}"
     
      customer = User.find(current_user.id)      
      if customer.nil?
        error!({ "error" => "authentication error", "detail" => "customer with username \"#{params[:email]}\" not found" }, 400)
      else
        AddPaymentProfileContext.call(customer, params[:payment_method_data])
      end
    end
  end  
end