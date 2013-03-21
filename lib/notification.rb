module Notification  
  extend self  
  
  def adapter  
    return @adapter if @adapter  
    self.adapter = :android  
    @adapter  
  end  
     
  def adapter=(adapter_name)  
    case adapter_name  
    when Symbol, String  
      require File.dirname(__FILE__) + "/notification_adapters/#{adapter_name}"
      @adapter = Notification::Adapters.const_get("#{adapter_name.to_s.capitalize}")  
    else  
      raise "Missing adapter #{adapter_name}"  
    end  
  end  
  
  def send(destination, message)  
    adapter.send(destination, message)  
  end  
end  