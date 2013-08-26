class OrderConfirmationMailer
  @queue = :email_queue

  def self.perform(sent_order, recipient)
  	p "ORDER ID #{sent_order['order']['id']}:Sending order confirmation email"

  	order = Order.find(sent_order['order']['id'])

  	OrderMailer.order_confirmation(order,recipient).deliver

  	p "ORDER ID #{sent_order['order']['id']}:Sent order confirmation email"
  end

  def on_failure_retry(e, *args)

  end
  
end