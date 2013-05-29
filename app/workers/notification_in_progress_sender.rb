class NotificationInProgressSender
  @queue = :notification_sender_queue

  def self.perform(order_id)

    order = Order.find(order_id)
  	order_number = nil

    if order.store_order_number.nil?
      order_number = order.number
    else
      order_number = order.store_order_number
    end

    message = Hash.new
    message[:order_id] = order.id
    message[:msg] = "Your order: #{order_number} has been received and will be ready in #{order.time_to_ready} minutes."

    device = Device.find_by_device_identifier(order.device_identifier).first

    devices = Array.new

    # get all devices for the store
    devices << device.device_token

    # logger.info "Order Id:#{order.id}Sent in progress notification. Time to ready: #{order.time_to_ready}" 

    Notification.adapter = order.device_type

    Notification.send(devices, message)
  end
end