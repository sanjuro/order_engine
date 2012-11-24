# Context to assocaite to add a new order
#
# curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"auth_token": "C3CDR1DCKZQ56NSMXL2BDZN8ZBS6LLL0", "user": {"full_name":"Test Customer","email": "shad6ster@gmail.com","mobile_number":"0833908314","password":"1234asd"}}' http://localhost:9000/api/v1/users/create.json
# Author::    Shadley Wentzel

class SignupCustomerContext
  attr_reader :user

  def self.call(user)
    SignupCustomerContext.new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    # create the new customer resource
    @customer = User.create(@user)
  end
end