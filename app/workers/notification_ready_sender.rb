class NotificationReadySender
  @queue = :notification_sender_queue

  def self.perform(order_id)

    order = Order.find(order_id)

    if order.store_order_number.nil?
      order_number = order.number
    else
      order_number = order.store_order_number
    end

    message = Hash.new
    message[:order_id] = order.id
    message[:msg] = "Your order: #{store_order_number} is ready for collection at #{order.store.store_name}."

    device = Device.find_by_device_identifier(order.device_identifier).first

    devices = Array.new

    # get all devices for the store
    # devices << "APA91bFX-US6bO_4AvYJNM5_cLf-v7klAqRob-9o8N13plxBBQutteXFnTbc8JbYvligGZRanJl8OYqcqOOlszHpRDW-It5SpfqdIfHDAPA63EdVqU7oX2W8zCZI3JDoEgLG5gFeTIC0qVl8iQw8KmYSEZXwJDmC_g"
    devices << device.device_token

    # logger.info "Order Id:#{order.id}Sent ready notification." 

    Notification.adapter = order.device_type

    Notification.send(devices, message)
  end
end