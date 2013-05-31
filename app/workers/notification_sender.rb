class NotificationSender
  @queue = :notification_sender_queue

  def self.perform(order_id)
    
   devices_stored = Array.new

    order = Order.find(order_id)
    # get all devices for the store
    order.store.devices.each do |device|
      case device.device_type
      when 'ios'
        p "ORDER ID #{order_id}:Sending ios notification"
        Notification.adapter = 'ios'

        message = Hash.new
        message[:order_id] = self.id
        message[:msg] = "Your order: #{order_number} has been received and will be ready in #{self.time_to_ready} minutes."
        message[:updated_at] = self.updated_at
        message[:store_order_number] = self.store_order_number
        message[:state] = self.state
        message[:time_to_ready] = self.time_to_ready

        Notification.send(device.device_token, message)
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