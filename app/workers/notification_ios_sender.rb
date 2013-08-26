class NotificationIosSender
  @queue = :notification_ios_queue

  def self.perform(destination, order_id, message)

    order = Order.find(order_id)

    p "ORDER ID #{order_id}:Sending ios notification"
    
    Notification.adapter = 'ios'

    Notification.send(destination, message)

    p "ORDER ID #{order_id}:Sent ios notification"
  end
end