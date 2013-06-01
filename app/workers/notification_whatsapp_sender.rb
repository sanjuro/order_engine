class NotificationWhatsappSender
  @queue = :notification_whatsapp_queue

  def self.perform(destination, order_id, message)

    order = Order.find(order_id)

    p "ORDER ID #{order_id}:Sending whatsapp notification"
    
    Notification.adapter = 'whatsapp'
   
    Notification.send(destination, message[:msg].to_s)

  end
end