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
    device = Device.find_by_device_identifier(device_data.device_identifier)

    if device.empty?
      # create a new device
      device = Device.create(
                :device_identifier => device_data.device_identifier,
                :device_type => device_data.device_type,
                :device_token => device_data.device_token,
                :deviceable_id => user.id,
                :deviceable_type => user.profileable_type,
                :is_active => true
                )

      case user.profileable_type
      when 'customer'
        device.deviceable_type = 'customer'
      when 'store_user'
        device.deviceable_type = 'store'
      end
        
      device.save
    end

    return { 
            "device_type" => device.device_type,
            "device_identifier" => device.device_identifier,
            "device_token" => device.device_token,
            "deviceable_type" => device.deviceable_type,
            "user" =>  user.format_for_web_serivce
            }
  end
end