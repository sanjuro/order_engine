require "pushmeup"  
  
module Notification  
  module Adapters  
    module Ios  
      extend self  
      def send(destination, message)  
        APNS.host = 'gateway.push.apple.com' 
        # gateway.sandbox.push.apple.com is default

        APNS.port = 2195 
        # this is also the default. Shouldn't ever have to set this, but just in case Apple goes crazy, you can.

        APNS.pem  = '/path/to/pem/file'
        # this is the file you just created

        APNS.pass = ''
        # Just in case your pem need a password
                
        # must be an hash with all values you want inside you notification
        APNS.send_notification(destination, message[:msg] )
       end  
    end  
  end  
end  