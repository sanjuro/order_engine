# Class to model the favourtie resource
#
# Author::    Shadley Wentzel
class Favourite < ActiveRecord::Base
	attr_accessible :favourtie_type, :favourite_id, :user_id

	belongs_to :user

  	scope :by_user, lambda {|store| where("favourites.user_id = ?", store)} 
end
