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
        GCM.key = "AIzaSyDknsHTiNaGy17pnEldoWQ5E7ZqYa-3Vcs"
        # GCM.key = "AIzaSyDTeqUmaRLyKn-odaePjksMoq-PFO2OHP8"
        
        # can be an string or an array of strings containing the regIds of the devices you want to send

        data = {:order_id => message[:order_id], :subject => message[:subject], :msg => message[:msg]}

        # must be an hash with all values you want inside you notification
        GCM.send_notification(destination, data)
       end  
    end  
  end  
end  