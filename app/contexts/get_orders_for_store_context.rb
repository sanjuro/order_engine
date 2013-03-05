# Context to retrieve a specific store
#
# Author::    Shadley Wentzel

class GetOrdersForStoreContext
  attr_reader :store_id, :state

  def self.call(store_id, state)
    GetOrdersForStoreContext.new(store_id, state).call
  end

  def initialize(store_id, state)
    @store_id, @state = store_id, state
  end

  def call
    	# return favourties
   	 	store = Store.find(@store_id)

    	orders = Order.by_store(@store_id).by_state(state).updated_on(Date.today)

	    orders_return = Hash.new

	    orders.each do |order|
	      orders_return[order.id] = order.format_for_web_serivce 
	    end

	    orders_return
  end
end