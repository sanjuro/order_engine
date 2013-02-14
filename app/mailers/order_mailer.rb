class OrderMailer < ActionMailer::Base

  def order_confirmation(order, recipient, resend = false)
    @order = order
    subject = "Order Confirmation: ##{order.number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

end