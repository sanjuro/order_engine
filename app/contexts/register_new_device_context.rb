# Context to register a new device
#
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
    # create a new device
    device = Device.create(
              :device_identifier => device_data.device_identifier,
              :deviceable_id => user.id,
              :deviceable_type => user.profileable_type,
              :is_active => true
              )

    case user.profileable_type
    when 'customer'
      device.device_type = 'customer'
    when 'store_user'
      device.device_type = 'store'
    end

    # set device token
    device.device_token
      
    device.save
  end
end