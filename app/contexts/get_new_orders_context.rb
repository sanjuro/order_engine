# Context to retrieve all new orders orders for today
#
# Author::    Shadley Wentzel
# curl -v -H 'Accept: application/json' -X POST -d '{"authentication_token": "AXSSSSED2ASDASD2"}' http://107.22.211.58:9000/api/v1/stores/new_orders -v

class GetNewOrdersContext

  def self.call
    GetNewOrdersContext.new().call
  end

  def initialize

  end

  def call
    orders = Order.select("orders.*, users.first_name, users.last_name, users.email, users.mobile_number").joins(:customer).today.order('created_at asc')

    orders_return = Hash.new

    orders.each do |order|
      orders_return[order.id] = order.format_with_store_for_web_serivce 
    end

    orders_return
  end
end