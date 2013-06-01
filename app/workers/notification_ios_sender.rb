class NotificationIosSender
  @queue = :notification_ios_queue

  def self.perform(order_id, message)

    order = Order.find(order_id)

    device = Device.find_by_device_identifier(order.device_identifier)

    p "ORDER ID #{order_id}:Sending ios notification"
    
    Notification.adapter = 'ios'

    Notification.send(device.device_token, message)
  end
end