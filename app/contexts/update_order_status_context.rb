# Context to update the status of an order
#
# curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"auth_token": "C3CDR1DCKZQ56NSMXL2BDZN8ZBS6LLL0", "order": {"address": {"alias":"Delivery","id_country": "US", "firstname":"test","lastname":"test","billing_name":"test","address1":"test","address2":"test","postcode":"1234","city":"test","phone":"8001231234"}}}' http://localhost:3000/api/v1/orders/144/add_address
# Author::    Shadley Wentzel

class UpdateOrderStatusContext
  attr_reader :user, :order, :status, :time_to

  def self.call(user, order, status, time_to)
    UpdateOrderStatusContext.new(user, order, status, time_to).call
  end

  def initialize(user, order, status, time_to)
    @user, @order, @status, @time_to = user, order, status, time_to
    @user.extend StoreUserRole
  end

  def call
    # return favourties
    @user.update_order_state(@order, @status, @time_to)
  end
end