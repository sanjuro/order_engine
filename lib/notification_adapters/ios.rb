# require "pushmeup"
require "urbanairship" 

module Notification
  module Adapters
    module Ios
      extend self
      def send(destination, message)
        # APNS.host = 'gateway.push.apple.com'
        # # gateway.sandbox.push.apple.com is default

        # APNS.port = 2195
        # # this is also the default. Shouldn't ever have to set this, but just in case Apple goes crazy, you can.
        
        # # APNS.pem = '/Users/macbookpro/Sites/vosto_order/cert.pem'
        # APNS.pem  = '/usr/share/vosto_order/shared/cert.pem'
        # # this is the file you just created

        # APNS.pass = ''
        # # Just in case your pem need a password

        # # must be an hash with all values you want inside you notification
        # # APNS.send_notification(destination, message[:msg] )
        # APNS.send_notification(destination, :alert => message[:msg],  :sound => 'default', 
        #                                 :other => {
        #                                   :data => {
        #                                     :ua => message[:updated_at], 
        #                                     :id => message[:order_id], 
        #                                     :son => message[:store_order_number],
        #                                     :state =>  message[:state], 
        #                                     :time =>  message[:time_to_ready]
        #                                     }})

        Urbanairship.application_key = 'q4WOfea4Tg6-uh7ukMI6TQ'
        Urbanairship.application_secret = '-qiVsDdxQESMXbgmCF_TeQ'
        Urbanairship.master_secret = 'fharThKnQzGDRfnuqTK-9A'
        Urbanairship.request_timeout = 5 # default

        notification = {
          :schedule_for => [Time.now],
          :device_tokens => [destination],
          :aps => {:alert => message[:msg],  
                   :sound => 'default', 
                                        :other => {
                                          :data => {
                                            :ua => message[:updated_at], 
                                            :id => message[:order_id], 
                                            :son => message[:store_order_number],
                                            :state =>  message[:state], 
                                            :time =>  message[:time_to_ready]
                                            }}}
        }

        Urbanairship.push(notification)

       end
    end
  end
end
