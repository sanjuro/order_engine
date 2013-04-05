# Context to assocaite to add a new order
#
# curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"authentication_token": "CXTTTTED2ASDBSD3", "user": {"first_name":"Test","last_name":"Customer","email": "test@gmail.com","mobile_number":"0833908314","birthday":"1981-12-04","user_pin":"12345"}}' http://localhost:9000/api/v1/users/create_customer.json
# Author::    Shadley Wentzel

class SignupCustomerContext
  attr_reader :user_params

  def self.call(user_params)
    SignupCustomerContext.new(user_params).call
  end

  def initialize(user_params)
    @user = user_params['user']
    @authentication_token = user_params['authentication_token']
  end

  def call

    # create the new customer resource
    @customer = Customer.new(
                            :first_name => @user[:first_name],
                            :last_name => @user[:last_name],
                            :email => @user[:email],
                            :mobile_number => @user[:mobile_number],
                            :user_pin => @user[:user_pin],
                            :profileable_type => 'customer'
                            )
    @customer.save

    # create access grant for new customer
    access_grant = AccessGrant.find_access(@authentication_token)
    @customer.create_access_grant(access_grant.client_application_id)
    @customer
  end
end