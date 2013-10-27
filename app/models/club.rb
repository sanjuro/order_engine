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
				"id" => self.id,
		        "club_name" => self.club_name,
		        "club_description" => self.club_description,
		        "is_active" => self.is_active,
		        "created_at" => self.created_at,
		        "club_image" => self.club_image,
		        "is_active" => self.is_active,
		        "store" => store.format_for_web_serivce,
		        "loyalties" => self.get_loyalties_info,
		        "deals" => self.get_deals_info		        
		}
	end 

	def get_deals_info
		deal_items = Array.new

		self.deals.each do |deal|
		  deal_item = deal
		  deal_item[:deal_name] = deal.deal_name
		  deal_item[:deal_description] = deal.deal_description 
		  deal_item[:deal_image] = deal.deal_image
		  deal_item[:time_frame] = deal.time_frame
		  deal_item[:redeem_code] = deal.redeem_code
		  deal_item[:prize] = deal.prize
		  deal_item[:is_active] = deal.is_active
		  deal_items << deal_item
		end

		return deal_items
	end

	def get_loyalties_info
		loyalty_items = Array.new

		self.loyalties.each do |loyalty|
		  loyalty_item = loyalty
		  loyalty_item[:name] = loyalty.name
		  loyalty_item[:description] = loyalty.description 
		  loyalty_item[:prize] = loyalty.prize
		  loyalty_item[:win_count] = loyalty.win_count
		  loyalty_item[:redeem_code] = loyalty.redeem_code
		  loyalty_item[:prize] = loyalty.prize
		  loyalty_item[:is_active] = loyalty.is_active
		  loyalty_items << loyalty_item
		end

		return loyalty_items
	end
end