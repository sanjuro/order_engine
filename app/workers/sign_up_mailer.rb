class SignUpMailer
  @queue = :email_queue

  def self.perform(customer_id)
  	p "CUSTOMER ID #{customer_id}:Sending sign up email"

  	customer = Customer.find(customer_id)

  	UserMailer.sign_up(customer).deliver

  	p "CUSTOMER ID #{customer_id}:Sent sign up email"
  end

  def on_failure_retry(e, *args)

  end
  
end