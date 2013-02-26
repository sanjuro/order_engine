# Class to model the device resource
#
# Author::    Shadley Wentzel
class Device < ActiveRecord::Base
	attr_accessible :device_type, :device_identifier, :is_active, :device_token,
					:deviceable_type, :deviceable_id

	scope :find_by_device_identifier, lambda {|device_identifier| where("devices.device_identifier = ?", device_identifier)}		
end