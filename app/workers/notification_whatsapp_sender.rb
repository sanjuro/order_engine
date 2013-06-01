class NotificationWhatsappSender
  @queue = :notification_whatsapp_queue

  def self.perform(order_id, message)

    order = Order.find(order_id)

  	device = Device.find_by_device_identifier(order.device_identifier).first

    p "ORDER ID #{order_id}:Sending whatsapp notification"
    
    Notification.adapter = 'whatsapp'
   
    Notification.send(device.device_token, message[:msg].to_s)

  end
end