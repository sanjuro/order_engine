class NotificationSender
  @queue = :notification_sender_queue

  def self.perform(device_type, device_token, mesasge)
	    Notification.adapter = device_type
		Notification.send(device_token, message)
  end
end