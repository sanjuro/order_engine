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
		# find store
		# store = Store.by_unique_id(order_data.unique_id)
		store = Store.by_unique_id('kau0000001').first

		# create order
		order = Order.create(
							:store_id => store.id,
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
		# @bbpc = BBPush::Client.new(	:app_id => "3159-s6B17c772Drm355O621r3D9i9486a923777",
  		#                          		:password => "smnBIWO3", 
		# 								:push_server_url => "https://cp3159.pushapi.eval.blackberry.com")

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
		orders = Order.by_user(self.id).order('created_at').page(page)

	    orders_return = Hash.new

	    orders.each do | order |
	      orders_return[order.id] = { 
	            "adjustment_total" => order.adjustment_total,
	            "completed_at" => order.completed_at,
	            "created_at" => order.created_at,
	            "credit_total" => order.credit_total,
	            "id" => order.id,
	            "item_total" => order.item_total,
	            "number" => order.number,
	            "payment_state" => order.payment_state,
	            "payment_total" => order.payment_total,
	            "special_instructions" => order.special_instructions,
	            "state" => order.state,
	            "store_id" => order.store_id,
	            "total" => order.total,
	            "updated_at" => order.updated_at,
	            "user_id" => order.user_id,
	            "line_items" => order.line_items
	      }
	    end

	    orders_return
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