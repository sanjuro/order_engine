class Customers < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'customers' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/store_users/authenticate.json?authentication_token=AXSSSSED2ASDASD1
    # curl -d '{"authentication_token": "CXTTTTED2ASDBSD4", "username": "gavs@lt.co.za", "password": "12345"}' 'http://127.0.0.1:9000/api/v1/customers/authenticate' -H Content-Type:application/json -v
   
    desc "Authenticates a Customer"
    params do
      requires :username, :type => String, :desc => "Username to authenticate."
      requires :password, :type => String, :desc => "Password to authenticate."
    end
    post '/authenticate' do
      authenticated_user
      logger.info "Authenticating Customer with Username: #{params[:username]}"

      customers = User.by_username(params[:username]).first      

      if customers.nil?
        throw :error, :status => 400, :message => "customer with username \"#{params[:username]}\" not found"
      else
        AuthenticateCustomerContext.call(customers, params[:password])
      end
    end
  end
  
end