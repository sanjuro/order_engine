class OrderMailer < ActionMailer::Base

  def order_confirmation(order, recipient, resend = false)
    @order = order
    subject = "Order Confirmation: ##{order.number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

  def in_progress(order, recipient, resend = false)
    @order = order
    subject = "Order In Progress: ##{order.number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

  def ready(order, recipient, resend = false)
    @order = order
    subject = "Order Ready: ##{order.number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

end