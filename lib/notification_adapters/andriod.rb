require "pushmeup"  
  
module Notification  
  module Adapters  
    module Andriod  
      extend self  
      def send(destination, message)  
        GCM.host = 'https://android.googleapis.com/gcm/send'
        # https://android.googleapis.com/gcm/send is default

        GCM.format = :json
        # :json is default and only available at the moment
        
        GCM.key = "AIzaSyAJ01_SRqfpNoGoyvJUjQaHGHZ2_UG_fcI" 
        # can be an string or an array of strings containing the regIds of the devices you want to send

        data = {:order_id => message[:order_id], :subject => message[:subject], :msg => 'new'}
        # must be an hash with all values you want inside you notification

        GCM.send_notification(destination, data)
       end  
    end  
  end  
end  