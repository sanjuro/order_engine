class LoyaltyAdder
  @queue = :loyalty_queue

  def self.perform(sent_order, user)
  	p "ORDER ID #{sent_order['order']['id']}:Calculating Loyalty"

  	order = Order.find(sent_order['order']['id'])

  	order.line_items.each do |line_item|
  		line_item.variant.add_loyalty(user['user']['id'])
  	end

  	p "ORDER ID #{sent_order['order']['id']}:Calculated Loyalty"
  end

  def on_failure_retry(e, *args)

  end
  
end