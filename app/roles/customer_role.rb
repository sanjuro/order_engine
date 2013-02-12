# Module create the Customer role
#
# Author::    Shadley Wentzel
require 'bbpush'
require 'net/smtp'

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
			if line_item.kind_of?(Array)
				variant = Variant.find(order_data[:line_items].variant_id.to_i)
				order.add_variant(variant,order_data[:line_items].quantity.to_i)
			else
				variant = Variant.find(line_item.variant_id.to_i)
				order.add_variant(variant, line_item.quantity.to_i)
			end
		end

		order.save!

		order.next

	    order.format_for_web_serivce 

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

	    orders.each do |order|
	      orders_return[order.id] = order.format_for_web_serivce 
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
	def authenticate(pin)
	    if self.valid_password?(pin)  
	      self
	    else
	      false
	    end
	end

	# Function to update a customer
	#
	# * *Args*    :
	#   - +user_data+ -> the array of user data
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def update_customer(user_data)
		user_data.each do |property,value|
        	self.send( "#{property}=", value )
        	self.save
        end 
        self
	end

	# Function to reset the pin of a csutomer
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def reset_pin
	    # generate new pin
	    new_pin = "#{Array.new(6){rand(6)}.join}"

	    self.user_pin = new_pin
	    self.generate_user_pin

	    # email pin to user
message = <<MESSAGE_END
From: Vosto Info <info@vosto.co.za>
To: #{self.full_name} <#{self.email}>
Subject: Reset Pin 

Your request to reset your pin has been processed and your new pin:

New Pin:#{new_pin}

Please keep it in a safe place.
MESSAGE_END

		Net::SMTP.start('mail.vosto.co.za', 25, 'vosto.co.za', 'info@vosto.co.za', 'R@d6hi@..', :plain) do |smtp|
		  smtp.send_message message, 'info@vosto.co.za', self.email
		end

		return { "success" => "new pin sent"}
	end
	  
	def valid_password?(password)
	    password = Digest::MD5::hexdigest("#{password}")
	    if password == encrypted_password
	      true
	    else
	      false
	    end
	end

	# Function to generate a new user pin
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def generate_user_pin
		self.user_pin = Digest::MD5::hexdigest("#{self.user_pin}")
		self.encrypted_password = Digest::MD5::hexdigest("#{self.user_pin}")
		self.save
  	end
end