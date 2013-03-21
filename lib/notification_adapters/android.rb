require "pushmeup"  
  
module Notification  
  module Adapters  
    module Android  
      extend self  
      def send(destination, message)  

        GCM.host = 'https://android.googleapis.com/gcm/send'
        # https://android.googleapis.com/gcm/send is default

        GCM.format = :json
        # :json is default and only available at the moment
        
        # GCM.key = "AIzaSyBY1PsWU8QK-LAh7zgbbtzEHx3okUVbG_8" 
        # GCM.key = "AIzaSyAS9YUgwXgVfhoZoteTMQ28cjkzWgcENoU"

        GCM.key = "AIzaSyDTeqUmaRLyKn-odaePjksMoq-PFO2OHP8"
        # can be an string or an array of strings containing the regIds of the devices you want to send

        data = {
          :order_id => message[:order_id], 
          :subject => message[:subject], 
          :state => message[:state],
          :time_to_ready => message[:time_to_ready],
          :msg => message[:msg]
        }
        # must be an hash with all values you want inside you notification
        p data
        p GCM.send_notification(destination, data)
       end  
    end  
  end  
end  