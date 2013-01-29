# Class to model the device resource
#
# Author::    Shadley Wentzel
class Device < ActiveRecord::Base
	attr_accessible :device_type, :device_identifier, :is_active, :device_message_token,
					:deviceable_type, :deviceable_id
end