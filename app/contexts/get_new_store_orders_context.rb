# Context to retrieve all new orders orders for a specific store
#
# Author::    Shadley Wentzel

class GetNewStoreOrdersContext
  attr_reader :store

  def self.call(store)
    GetNewStoreOrdersContext.new(store).call
  end

  def initialize(store)
    @store = store
  end

  def call
    orders = Order.select("orders.*, users.first_name, users.last_name, users.email, users.mobile_number").sent_to_store.joins(:customer).by_store(@store.id).order('created_at asc')

    orders_return = Hash.new

    orders.each do |order|
      orders_return[order.id] = order.format_for_web_serivce 
    end

    orders_return
  end
end