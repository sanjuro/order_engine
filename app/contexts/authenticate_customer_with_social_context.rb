# Context to authenticate a customer
#
# 
# Author::    Shadley Wentzel

class AuthenticateCustomerWithSocialContext
  attr_reader :email

  def self.call(email)
    AuthenticateCustomerWithSocialContext.new(email).call
  end

  def initialize(email)
    @email = email
  end

  def call
    # convert query termm
    customer = User.where("users.email = ?", @email).first

    if customer
      customer.authentication_token
     
      payment_profile = PaymentProfile.active.by_customer(customer.id).first
    
      if payment_profile.nil?
        payment_method_id = 0
      else 
        payment_method_id = payment_profile.payment_method_id
      end
    
      return_data = Hash.new
      return_data =  { 
              :authentication_token => customer.authentication_token,
              :full_name => customer.full_name,
              :first_name => customer.first_name,
              :last_name => customer.last_name,
              :username => customer.username,
              :email => customer.email,
              :mobile_number => customer.mobile_number,
              :payment_method => payment_method_id
            }
      p return_data
      p "HERE3"
      return { 
              :authentication_token => customer.authentication_token,
              :full_name => customer.full_name,
              :first_name => customer.first_name,
              :last_name => customer.last_name,
              :username => customer.username,
              :email => customer.email,
              :mobile_number => customer.mobile_number,
              :payment_method => payment_method_id
            }
    else 
      return false
    end
  end
end