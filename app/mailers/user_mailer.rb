class UserMailer < ActionMailer::Base

  def new_pin(pin, recipient, resend = false)
    @pin = pin
    subject = "New Pin Generated"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
      :subject => subject)
  end

end