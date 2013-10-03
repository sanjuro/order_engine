class UserMailer < ActionMailer::Base

  def new_pin(pin, recipient, resend = false)
    @pin = pin
    subject = "New Pin Generated"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
      :subject => subject)
  end

  def sign_up(customer, resend = false)
    @customer = customer
    subject = "New Sign Up"
    mail(:to => customer.email,
    	 :from    => "info@vosto.co.za",
      	 :subject => subject)
  end

  def vosto_sign_up(customer, resend = false)
    @customer = customer
    subject = "New Customer Sign Up"
    mail(:to => "info@vosto.co.za",
    	 :from    => "info@vosto.co.za",
      	 :subject => subject)
  end

  def vosto_first_order(customer, resend = false)
    @customer = customer
    subject = "First Time Customer Order"
    mail(:to => "info@vosto.co.za",
    	 :from    => "info@vosto.co.za",
      	 :subject => subject)
  end

end