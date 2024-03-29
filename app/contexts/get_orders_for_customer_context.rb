# Context to retrieve a specific store
#
# Author::    Shadley Wentzel

class GetOrdersForCustomerContext
  attr_reader :user

  def self.call(user)
    GetOrdersForCustomerContext.new(user).call
  end

  def initialize(user)
    @user = user
    @user.extend CustomerRole
  end

  def call
    @user.get_orders(100)
  end
end