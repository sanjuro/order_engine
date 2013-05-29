class NotificationSender
  @queue = :notification_sender_queue

  def self.perform(order_id)
  	

    devices_stored = Array.new

    order = Order.find(order_id)

    # get all devices for the store
    order.store.devices.each do |device|
    	case device.device_type
    	when 'android'
		    Notification.adapter = 'android'

		    message = Hash.new
		    message[:order_id] = self.id
		    message[:msg] = "new"

		    devices_stored = Array.new

		    Notification.send(devices_stored, message)
    	when 'whatsapp'
	    	Notification.adapter = 'whatsapp'
	      message = order.format_for_whatsapp
	  		Notification.send(device.device_token, message.to_s)
	  	end
    end
  end
end