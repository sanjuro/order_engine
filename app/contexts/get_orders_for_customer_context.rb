# Context to retrieve a specific store
#
# Author::    Shadley Wentzel

class GetOrdersForCustomerContext
  attr_reader :customer_id

  def self.call(customer_id)
    GetOrdersForCustomerContext.new(customer_id).call
  end

  def initialize(customer_id)
    @customer_id = customer_id
  end

  def call
    	# return favourties

    	orders = Order.by_user(@customer_id)

	    orders_return = Hash.new

	    orders.each do |order|
	      orders_return[order.id] = order.format_for_web_serivce 
	    end

	    orders_return
  end
end