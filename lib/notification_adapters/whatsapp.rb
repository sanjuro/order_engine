require "pushmeup"  
  
module Notification  
  module Adapters  
    module Whatsapp  
      extend self  
      def send(destination, message) 
        # p message   
        if destination.kind_of?(Array)
          destination.each do |number|
            command = "php /usr/share/vosto_order/current/whatsapp/vosto_sender.php #{number} '#{message}'"     
            system(command)          
          end
        else
          command = "php /usr/share/vosto_order/current/whatsapp/vosto_sender.php #{destination} '#{message}'"     
          system(command)
        end 
      end
    end  
  end  
end  