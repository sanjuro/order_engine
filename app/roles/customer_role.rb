# Module create the Customer role
#
# Author::    Shadley Wentzel

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