class ReadyMailer
  @queue = :email_queue

  def self.perform(sent_order, recipient)
  	p "ORDER ID #{sent_order['order']['id']}:Sending ready email"

  	order = Order.find(sent_order['order']['id'])

  	OrderMailer.ready(order,recipient).deliver

  	p "ORDER ID #{sent_order['order']['id']}:Sent ready email"
  end

  def on_failure_retry(e, *args)

  end
  
end