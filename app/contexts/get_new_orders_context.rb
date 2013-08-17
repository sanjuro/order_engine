# Context to retrieve all new orders orders for today
#
# Author::    Shadley Wentzel

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
      orders_return[order.id] = order.format_for_web_serivce 
    end

    orders_return
  end
end