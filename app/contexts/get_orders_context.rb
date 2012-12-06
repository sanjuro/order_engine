# Context to retrieve all orders for a user
#
# Author::    Shadley Wentzel
class GetOrdersContext
  attr_reader :user

  def self.call(user)
    GetOrdersContext.new(user).call
  end

  def initialize(user)
    @user = user
    @user.extend CustomerRole
  end

  def call
    @user.get_orders
  end
end