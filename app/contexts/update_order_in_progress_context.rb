# Context to update an order to the in progress state
#
# curl -v -H 'Accept: application/json' -X PUT -d '{"authentication_token": "81dc9bdb52d04dc20036dbd8313ed055", "time_to_ready": "15"}' http://localhost:9000/api/v1/orders/28/in_progress
# Author::    Shadley Wentzel

class UpdateOrderInProgressContext
  attr_reader :user, :order, :time_to_ready

  def self.call(user, order, time_to_ready)
    UpdateOrderInProgressContext.new(user, order, time_to_ready).call
  end

  def initialize(user, order, time_to_ready)
    @time_to_ready, @order = time_to_ready, order
    @user = user.extend StoreUserRole
  end

  def call
    # update status of orer
    @user.update_order_state(@order, 'in_progress', @time_to_ready)
  end
end