# Context to update an order to the ready state
#
# curl -v -H 'Accept: application/json' -X PUT -d '{"authentication_token": "81dc9bdb52d04dc20036dbd8313ed055", "time_to_ready": "15"}' http://localhost:9000/api/v1/orders/28/ready
# Author::    Shadley Wentzel

class UpdateOrderReadyContext
  attr_reader :user, :order

  def self.call(user, order)
    UpdateOrderReadyContext.new(user, order).call
  end

  def initialize(user, order)
    @order = order
    @user = user.extend StoreUserRole
  end

  def call
    # update status of orer
    @user.update_order_state(@order, 'ready', 0)
  end
end