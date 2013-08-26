class NotificationPusherSender
  @queue = :notification_pusher_queue

  def self.perform(event, user_id, order_id, message)

    order = Order.find(order_id)

    p "ORDER ID #{order_id}:Sending pusher notification"

    Pusher.app_id = '37591'
    Pusher.key = 'be3c39c1555da94702ec'
    Pusher.secret = 'deae8cae47a1c88942e1'
    Pusher['order'].trigger(event, {:user_id => user_id, :message => message})

    p "ORDER ID #{order_id}:Sent pusher notification"

  end

  def on_failure_retry(e, *args)

  end
  
end