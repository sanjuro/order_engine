class NewUserPinMailer
  @queue = :email_queue

  def self.perform(user_id, pin, recipient)
  	p "CUSTOMER ID #{user_id}:Sending new pin"

  	UserMailer.new_pin(pin,recipient).deliver

 	p "CUSTOMER ID #{user_id}:Sent new pin"
  end

  def on_failure_retry(e, *args)

  end
  
end