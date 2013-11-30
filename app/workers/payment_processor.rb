class PaymentProcessor
  @queue = :payment

  def self.perform(order_id)
  	p "Order ID #{order_id}:Doing Payment"

  	order = Order.find(order_id)

    payment = order.payments.first

    payment_profile = PaymentProfile.active.by_customer(order.user_id).first

    EM.run do
      Fiber.new {

      if payment_profile.nil?
        p "Order ID #{order.id}:Doing Cash Payment"
        DoCashPaymentContext.call(order.customer, order)
      else
        case payment_profile.payment_method_id
        when 1
          p "Order ID #{order.id}:Doing Cash Payment"
          DoCashPaymentContext.call(order.customer, order)
        when 2
          p "Order ID #{order.id}:Doing Credit Card Payment"
          DoCreditCardPaymentContext.call(order.customer, order)
        else
          p "Order ID #{order.id}:Doing Default Payment"
          DoCashContext.call(order.customer, order)
        end
      end

        EM.stop
      }.resume
    end
  	
  end

  def on_failure_retry(e, *args)

  end
  
end