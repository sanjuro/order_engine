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
		store = Store.by_unique_id(order_data[:unique_id]).first

		# create order
		order = Order.create(
							:store_id => store.id,
							:user_id => self.id,
							:state => 'confirm',
							:device_identifier => order_data[:device_identifier],
							:device_type => order_data[:device_type],
							:special_instructions => order_data[:special_instructions]
							)

		order_data[:line_items].each do |line_item|
			order_item = line_item.last
			variant = Variant.find(order_item.variant_id)
			order.add_variant(variant, order_item.quantity)
		end

		order.save!

		order.next

	    order.formant_for_web_serivce 

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
	      orders_return[order.id] = order.formant_for_web_serivce 
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

	# Function to authenticate a customer
	#
	# * *Args*    :
	#   - +password+ -> the password
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def authenticate(password)
	    if self.valid_password?(password)  
	      self
	    else
	      nil
	    end
	end
	  
	def encrypt_password
	    if password.present?
	      self.password_salt = BCrypt::Engine.generate_salt
	      self.encrypted_password = BCrypt::Engine.hash_secret(password, password_salt)
	    end
	end

	def valid_password?(password)
	    return false if encrypted_password.blank?
	    bcrypt   = ::BCrypt::Password.new(encrypted_password)
	    password = ::BCrypt::Engine.hash_secret("#{password}", bcrypt.salt)
	    if password == encrypted_password
	      true
	    else
	      false
	    end
	end
end