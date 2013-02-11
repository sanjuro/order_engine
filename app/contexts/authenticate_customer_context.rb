# Context to authenticate a customer
#
# 
# Author::    Shadley Wentzel

class AuthenticateCustomerContext
  attr_reader :user, :password

  def self.call(user, password)
    AuthenticateCustomerContext.new(user, password).call
  end

  def initialize(user, password)
    @user = user.extend CustomerRole
    @password = password
  end

  def call
    # convert query termm
    customer = @user.authenticate(@password)

    if customer
      customer.authentication_token

      store = customer.stores.first
      
      return { 
              :authentication_token => customer.authentication_token,
              :full_name => customer.full_name,
              :first_name => customer.first_name,
              :last_name => customer.last_name,
              :username => customer.username,
              :email => customer.email,
              :mobile_number => customer.mobile_number,
              :store_id => store.id
            }
    else 
      return false
    end
  end
end