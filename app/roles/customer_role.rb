# Module create the Customer role
#
# Author::    Shadley Wentzel
require 'bbpush'

module CustomerRole

	# Function to create a new order
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def create_new_order(order_data)
		# create order
		order = Order.create(
							:store_id => order_data.store_id,
							:user_id => self.id,
							:state => 'confirm',
							:device_identifier => order_data.device_identifier,
							:device_type => order_data.device_type,
							:special_instructions => order_data.special_instructions
							)

		order_data[:line_items].each do |line_item|
			order_item = line_item.last
			variant = Variant.find(order_item.variant_id)
			order.add_variant(variant, order_item.quantity)
		end

		order.save!

		order.next

		# create notification
		# @bbpc = BBPush::Client.new(	:app_id=>"yourappidhere",
  		#                          		:password=>"yourpasswordhere", 
		# 								:push_server_url=>"https://cp123.pushapi.na.blackberry.com/mss/PD_pushRequest")

		# @bbpc.send_notification(["12345678"], "Hello to the device with PIN 12345678!", 5)
	end

	# Function to get orders for a customer
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def get_orders(page=30)
		@page = page
		Order.by_user(self.id).order('created_at').page(1)
	end

	# Function to get favourites for a customer
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def get_favourites
		Favourite.by_user(self.id)
	end
end