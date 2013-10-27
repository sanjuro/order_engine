# Class to model the deal resource
#
# Author::    Shadley Wentzel
class Deal < ActiveRecord::Base
	attr_accessible :deal_name, :deal_description, :is_active, :dealable_type, :dealable_id, :prize,
					:time_frame, :redeem_code, :created_at, :completed_at, :updated_at

	belongs_to :club

	has_many :images, :as => :viewable, :order => :position

	def deal_image
		self.images.first.small_url
	end

	def format_for_web_serivce
		deal_return = Hash.new

		store = Store.find(self.dealable_id)

		deal_return = { 
		        "deal_name" => self.deal_name,
		        "deal_description" => self.deal_description,
		        "created_at" => self.created_at,
		        "dealable_type" => self.dealable_type,
		        "dealable_id" => self.dealable_id,
		        "deal_image" => self.deal_image,
		        "time_frame" => self.time_frame,
		        "redeem_code" => self.redeem_code,
		        "prize" => self.prize,
		        "is_active" => self.is_active,
		        "store" => store.format_for_web_serivce
		}
	end 
end