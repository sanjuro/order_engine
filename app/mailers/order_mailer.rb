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
    if order.store_order_number.nil?
      order_number = order.number
    else
      order_number = order.store_order_number
    end
    subject = "Order In Progress: ##{order_number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

  def ready(order, recipient, resend = false)
    @order = order
    if order.store_order_number.nil?
      order_number = order.number
    else
      order_number = order.store_order_number
    end
    subject = "Order Ready: ##{order_number}"
    mail(:to => recipient,
    	 :from    => "info@vosto.co.za",
         :subject => subject)
  end

end