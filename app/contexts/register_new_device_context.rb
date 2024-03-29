# Context to register a new device
#
# Author::    RegisterNewDeviceContext Wentzel

class RegisterNewDeviceContext
  attr_reader :device_data, :user

  def self.call(device_data, user)
    RegisterNewDeviceContext.new(device_data, user).call
  end

  def initialize(device_data, user)
    @device_data, @user = device_data, user
  end

  def call
    device = Device.where("devices.device_identifier = ?", device_data.device_identifier).first

    if device.nil?
      # create a new device
      device = Device.create(
                :device_identifier => device_data.device_identifier,
                :device_type => device_data.device_type,
                :device_token => device_data.device_token,               
                :deviceable_type => user.profileable_type,
                :is_active => true
                )
   else
      device.device_identifier = device_data.device_identifier
      device.device_type = device_data.device_type
      device.device_token = device_data.device_token
    end

    case user.profileable_type
    when 'customer'
      device.deviceable_type = 'customer'
      device.deviceable_id = user.id
    when 'store_user'
      device.deviceable_type = 'store'
      device.deviceable_id = user.stores.first.id
    end
      
    device.save

    return { 
            "device_type" => device.device_type,
            "device_identifier" => device.device_identifier,
            "device_token" => device.device_token,
            "deviceable_type" => device.deviceable_type,
            "user" =>  user.format_for_web_serivce
            }
  end
end