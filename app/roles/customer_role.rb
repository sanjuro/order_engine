# Module create the Customer role
#
# Author::    Shadley Wentzel
require 'bbpush'

module CustomerRole

	# Function to pay an order, invokes the pay method on the specific orde
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def create_new_order(order)
		# create order
		p 'poes'
		exit
		# create notification
		@bbpc = BBPush::Client.new(	:app_id=>"yourappidhere",
                           			:password=>"yourpasswordhere", 
									:push_server_url=>"https://cp123.pushapi.na.blackberry.com/mss/PD_pushRequest")

		@bbpc.send_notification(["12345678"], "Hello to the device with PIN 12345678!", 5)
	end

	# Function to pay an order, invokes the pay method on the specific orde
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

	# Function to pay an order, invokes the pay method on the specific orde
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