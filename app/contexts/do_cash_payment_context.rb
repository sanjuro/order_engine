# Context to do a credit card payment
#
# Author::    Shadley Wentzel

class DoCashPaymentContext
  attr_reader :user, :order

  def self.call(user, order)
    DoCashPaymentContext.new(user, order).call
  end

  def initialize(user, order)
    @user = user.extend CustomerRole
    @order = order
  end

  def call
  	customer = @user    
  
    # create payment profile
    status_code = "Success"
  end

end