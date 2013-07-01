# Module create the Customer role
#
# Author::    Shadley Wentzel
require 'bbpush'
require 'net/smtp'
require 'bcrypt'

module CustomerRole

  SHIPPING_METHOD_TYPE_DELIVERY = 2

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
							:is_delivery => order_data[:is_delivery],
							:device_identifier => order_data[:device_identifier],
							:device_type => order_data[:device_type],
							:store_order_number => order_data[:store_order_number]
							)

		order_data[:line_items].each do |line_item|
			if line_item.kind_of?(Array)
				variant = Variant.find(order_data[:line_items].variant_id.to_i)
				order.add_variant(variant,order_data[:line_items].quantity.to_i, order_data[:line_items].special_instructions)
			else
				variant = Variant.find(line_item.variant_id.to_i)
				order.add_variant(variant, line_item.quantity.to_i, line_item.special_instructions)
			end
		end

		order.save!
		
		if !order_data[:ship_address].nil?

			shipping_method = ShippingMethod.where('store_id = ?', store.id).where('shipping_method_type_id = ?', SHIPPING_METHOD_TYPE_DELIVERY).first

			order.shipping_method = shipping_method

			shipping_data = order_data[:ship_address][0]

			suburb = Suburb.find(shipping_data.suburb_id)

			state = State.find(suburb,state_id)

			ship_address = Address.create(
							:address1 => shipping_data.address1,
							:address2 => shipping_data.address2,
							:city => shipping_data.city,
							:zipcode => shipping_data.zipcode,
							:country_id => state.country_id,
							:suburb_id => shipping_data.suburb_id,
							:latitude => shipping_data.latitude,
							:longitude => shipping_data.longitude,
							:state_id => state.id,
							:state_name => state.name
							)
			
			order.ship_address = ship_address
			order.save!

			order.create_shipment!
			
		end

		order.next

	    order.format_for_web_serivce 

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
	def get_orders(page=10)
		@page = page
		orders = Order.by_user(self.id).order('created_at DESC').page(page)

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
			if property == 'user_pin'
				value = BCrypt::Password.create("#{value}")
				self.send( "encrypted_password=", value )
			end
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
	    new_pin = "#{Array.new(5){rand(5)}.join}"

	    new_encrypted_password = BCrypt::Password.create(new_pin)

		self.user_pin = new_encrypted_password
		self.encrypted_password = new_encrypted_password
		self.save

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
	    return false if encrypted_password.blank?
	    # extract salt from encryped password
	    @user_password  = BCrypt::Password.new(encrypted_password)	   
	    if @user_password == password
	      true
	    else
	      false
	    end
	end	
end