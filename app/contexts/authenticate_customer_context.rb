# Context to authenticate a customer
#
# 
# Author::    Shadley Wentzel

class AuthenticateCustomerContext
  attr_reader :user, :pin

  def self.call(user, pin)
    AuthenticateCustomerContext.new(user, pin).call
  end

  def initialize(user, pin)
    @user = user.extend CustomerRole
    @pin = pin
  end

  def call
    # convert query termm
    customer = @user.authenticate(@pin)

    if customer
      customer.authentication_token
      
      return { 
              :authentication_token => customer.authentication_token,
              :full_name => customer.full_name,
              :first_name => customer.first_name,
              :last_name => customer.last_name,
              :username => customer.username,
              :email => customer.email,
              :mobile_number => customer.mobile_number
            }
    else 
      return false
    end
  end
end