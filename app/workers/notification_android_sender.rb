class NotificationAndroidSender
  @queue = :notification_android_queue

  def self.perform(order_id, message)
  	p message
    order = Order.find(order_id)

    device = Device.find_by_device_identifier(order.device_identifier)

    p "ORDER ID #{order_id}:Sending android notification"
    
    Notification.adapter = 'android'

    Notification.send(device.device_token, message)

  end
end