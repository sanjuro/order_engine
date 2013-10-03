class FirstTimeOrderUpMailer
  @queue = :email_queue

  def self.perform(customer_id)
  	p "CUSTOMER ID #{customer_id}:Sending first time order mail"

  	orders = Order.by_user(customer_id)
  	customer = Customer.find(customer_id)

  	if (orders.count == 1) 
  		UserMailer.vosto_first_order(customer).deliver
  		p "CUSTOMER ID #{customer_id}:Sent first time order mail"
  	end

  	
  end

  def on_failure_retry(e, *args)

  end
  
end