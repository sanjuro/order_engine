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
    orders = Order.select("orders.*, users.first_name, users.last_name, users.email, users.mobile_number").sent_to_store.joins(:customer).by_store(@store.id)

    orders_return = Hash.new

    orders.each do | order |
      orders_return[order.id] = { 
            "adjustment_total" => order.adjustment_total,
            "completed_at" => order.completed_at,
            "created_at" => order.created_at,
            "credit_total" => order.credit_total,
            "id" => order.id,
            "item_total" => order.item_total,
            "number" => order.number,
            "payment_state" => order.payment_state,
            "payment_total" => order.payment_total,
            "special_instructions" => order.special_instructions,
            "state" => order.state,
            "store_id" => order.store_id,
            "total" => order.total,
            "updated_at" => order.updated_at,
            "user_id" => order.user_id,
            "order_items" => order.line_items
      }
    end

    orders_return
  end
end