class NotificationAndroidSender
  @queue = :notification_android_queue

  def self.perform(destination, order_id, message)
  
    order = Order.find(order_id)

    p "ORDER ID #{order_id}:Sending android notification"
    
    Notification.adapter = 'android'

    Notification.send(destination, message)

  end
end