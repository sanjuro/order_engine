# Context to do a credit card payment
#
# Author::    Shadley Wentzel

class DoCreditCardPaymentContext
  attr_reader :user, :order

  def self.call(user, order)
    DoCreditCardPaymentContext.new(user, order).call
  end

  def initialize(user, order)
    @user = user.extend CustomerRole
    @order = order
  end

  def call
  	customer = @user    
  
    # create payment profile
    status_code = customer.pay_with_credit_card(order)
  end

end