class VostoSignUpMailer
  @queue = :email_queue

  def self.perform(customer_id)
  	p "CUSTOMER ID #{customer_id}:Sending new customer signup mail"

  	customer = Customer.find(customer_id)

  	UserMailer.vosto_sign_up(customer).deliver

  	p "CUSTOMER ID #{customer_id}:Sent new customer signup mail"
  end

  def on_failure_retry(e, *args)

  end
  
end