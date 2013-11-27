# Context to create a new payment profile for a customer
#
# curl -i -X POST -d '{"authentication_token": "b228b017e445b55b368c9608546a1ea1","payment_method_data": {"payment_method": "2", "cc_number": "1234123412341234", "unique_indentifier": "b228b017e445b55b368c9608546a1ea1","device_indentifier": "360d25535fdbb6c4", "payment_hash":"b2234b017e445b55b368c9608546a1ea1"}}' http://127.0.0.1:9000/api/v1/customers/add_payment_profile -v
# Author::    Shadley Wentzel

class AddPaymentProfileContext
  attr_reader :user, :payment_method_data

  def self.call(user, payment_method_data)
    AddPaymentProfileContext.new(user, payment_method_data).call
  end

  def initialize(user, payment_method_data)
    @user = user.extend CustomerRole
    @payment_method_data = payment_method_data
  end

  def call
    # convert query termm
    customer = @user
    
    # call gateway function
    payment_method = PaymentMethod.find(payment_method_data[:payment_method])
	  secured_data = payment_method.create_profile(payment_method_data).as_json
    
    payment_data = Hash.new
    # create payment data
    case payment_method.id
      when 1
        payment_data = { :cash => 1 }
      when 2
        # secured_pin = secured_data[:secured_card_info]   
        payment_data = {
            :secured_card_info => secured_data["secured_card_info"],
            :hash_value => secured_data["hash_value"]     
        }
      else
        payment_data = { :cash => 1 }
    end
  
    # create payment profile on Vosto
    unique_token = customer.create_payment_profile(payment_method, payment_data)

    payment_return = Hash.new
    # return secured pin 
    payment_return = {
        :secured_card_info => secured_data["secured_card_info"],
        :unique_token => unique_token,
        :payment_method => payment_method.id
      } 
  end

  def encrypt(key, data)
    cipher = OpenSSL::Cipher::Cipher.new('des-ede3')
    cipher.encrypt
    input = data
    cipher.key = key

    result = cipher.update(input) + cipher.final    
    encoded = Base64.encode64(result).encode('utf-8')
    encoded.strip 
  end
end