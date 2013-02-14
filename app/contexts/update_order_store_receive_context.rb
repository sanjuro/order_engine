# Context to show that a store has received an order
#
# curl -v -H 'Accept: application/json' -X POST -d '{"authentication_token": "81dc9bdb52d04dc20036dbd8313ed055"}' http://localhost:9000/api/v1/orders/28/store_receive
# Author::    Shadley Wentzel

class UpdateOrderStoreReceiveContext
  attr_reader :user, :order

  def self.call(user, order)
    UpdateOrderStoreReceiveContext.new(user, order).call
  end

  def initialize(user, order)
    @order = order
    @user = user.extend StoreUserRole
  end

  def call
    # update status of order
    @user.update_order_state(@order, 'store_receive', 0)
  end
end