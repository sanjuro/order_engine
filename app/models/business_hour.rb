# Class to model the BusinessHours resource
#
# Author::    Shadley Wentzel
class BusinessHour < ActiveRecord::Base

	attr_accessible :day, :open_time, :close_time

	belongs_to :store

  def format_for_web_serivce
    business_hour_return = Hash.new

    business_hour_return = { 
            "open_time" => self.open_time,
            "close_time" => self.close_time,
            "day" => self.day
    }
  end 
end