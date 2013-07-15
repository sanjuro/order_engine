module Notification  
  module Adapters  
    module Web  
      extend self  
      def send(destination, message)  
        Pusher.app_id = '37591'
        Pusher.key = 'be3c39c1555da94702ec'
        Pusher.secret = 'deae8cae47a1c88942e1'
        Pusher['order'].trigger('new_order_event', {:user_id => destination,:message => message})
       end  
    end  
  end  
end  