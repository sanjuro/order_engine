require "pushmeup"  
  
module Notification  
  module Adapters  
    module Whatsapp  
      extend self  
      def send(destination, message)   
        if destination.kind_of?(Array)
          destination.each do |number|
            # command = "php /Users/macbookpro/Sites/vosto_order/whatsapp/vosto_sender.php #{number} '#{message}'"  
            command = "php /usr/share/vosto_order/current/whatsapp/vosto_sender.php #{number} '#{message}'"         
            system(command)          
          end
        else
          # p "php /Users/macbookpro/Sites/vosto_order/whatsapp/vosto_sender.php #{destination} '#{message}'" 
          # command = "php /Users/macbookpro/Sites/vosto_order/whatsapp/vosto_sender.php #{destination} '#{message}'"  
          command = "php /usr/share/vosto_order/current/whatsapp/vosto_sender.php #{destination} '#{message}'"   
          system(command)
        end 
      end
    end  
  end  
end  