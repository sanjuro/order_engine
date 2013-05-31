class NotificationSender
  @queue = :notification_sender_queue

  def self.perform(order_id)
    
   devices_stored = Array.new

    order = Order.find(order_id)
    # get all devices for the store
    order.store.devices.each do |device|
      case device.device_type
      when 'android'
        p "ORDER ID #{order_id}:Sending android notification"
        Notification.adapter = 'android'

        message = Hash.new
        message[:order_id] = order.id
        message[:msg] = "new"

        Notification.send(device.device_token, message)
      when 'whatsapp'
        p "ORDER ID #{order_id}:Sending whatsapp notification"
        Notification.adapter = 'whatsapp'
        message = order.format_for_whatsapp
        Notification.send(device.device_token, message.to_s)
      end
    end
  end
end