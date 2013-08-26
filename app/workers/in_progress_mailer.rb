class InProgressMailer
  @queue = :email_queue

  def self.perform(sent_order, recipient)
  	p "ORDER ID #{sent_order['order']['id']}:Sending in progress email"

  	order = Order.find(sent_order['order']['id'])

  	OrderMailer.in_progress(order,recipient).deliver

  	p "ORDER ID #{sent_order['order']['id']}:Sent in progress email"
  end

  def on_failure_retry(e, *args)

  end
  
end