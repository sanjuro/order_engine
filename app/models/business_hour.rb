# Class to model the BusinessHours resource
#
# Author::    Shadley Wentzel
class BusinessHour < ActiveRecord::Base

	attr_accessible :day, :open_time, :close_time

	belongs_to :store
end