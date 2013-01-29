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
    orders = Order.select("orders.*, users.first_name, users.last_name, users.mobile_number").sent_to_store.joins(:customer).by_store(@store.id)
  end
end