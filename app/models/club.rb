# Class to model the club resource
#
# Author::    Shadley Wentzel
class Club < ActiveRecord::Base

  	include Sunspot::ActiveRecord

	attr_accessible :unique_id, :club_name, :club_description, :is_active, :tag,
					:address, :tagline, :latitude, :longitude, :created_at, :completed_at, :updated_at

	belongs_to :store

	has_many :images, :as => :viewable, :order => :position
	has_many :deals
	has_many :loyalties

	geocoded_by :address, :latitude => :latitude, :longitude => :longitude
	# after_validation :geocode, :if => :address_changed?
	# reverse_geocoded_by :latitude, :longitude
	# after_validation :reverse_geocode 

	Sunspot.setup(Club) do
		text :club_name
		string :unique_id
		text :tag
		string :address
		boolean :is_active
		location (:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
		# string(:location, :as => :location) { [lat,lng].join(",") }
	end

	def club_image
		self.images.first.small_url
	end

	def format_for_web_serivce
		club_return = Hash.new

		club_return = { 
		        "club_name" => self.club_name,
		        "club_description" => self.club_description,
		        "is_active" => self.is_active,
		        "created_at" => self.created_at,
		        "club_image" => self.club_image,
		        "is_active" => self.is_active,
		        "store" => store.format_for_web_serivce
		}
	end 
end