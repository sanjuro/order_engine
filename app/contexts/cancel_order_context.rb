# Context to cancel an order
#
#
# Author::    Shadley Wentzel

class CancelOrderContext
  attr_reader :user, :order

  def self.call(user, order)
    CancelOrderContext.new(user, order).call
  end

  def initialize(user, order)
    @order = order
    @user = user.extend StoreUserRole
  end

  def call
    # cancel order
    @user.cancel_order(@order)
  end
end