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

			shipping_data = order_data[:ship_address]

			suburb = Suburb.find(shipping_data.suburb_id)

			state = store.state
	
			ship_address = Address.create(
							:address1 => shipping_data.address1,
							:address2 => shipping_data.address2,
							:city => shipping_data.city,
							:zipcode => shipping_data.zipcode,
							:country_id => 187,
							:suburb_id => shipping_data.suburb_id,
							# :latitude => shipping_data.latitude,
							# :longitude => shipping_data.longitude,
							:state_id => state.id,
							:state_name => state.name
							)
			
			order.ship_address = ship_address
			order.save!

			order.create_shipment!
			
		end

		# send first time order mail if it is first time
    	Resque.enqueue(FirstTimeOrderUpMailer, self.id)
		
		order.next

	    order.format_for_web_serivce 

	end

	# Function to get orders for a customer
	#
	# * *Args*    :
	#   - +page+ -> the pagination size
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def get_orders(page=10)
		@page = page

		orders = Order.by_user(self.id).order('created_at DESC')

	    orders_return = Array.new

	    orders.each do |order|	    	
	      orders_return << order.format_with_store_for_web_serivce 
	    end

	    orders_return
	end

	# Function to get orders for a customer
	#
	# * *Args*    :
	#   - +page+ -> the pagination size
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def get_orders_objects(page=10)
		@page = page

		orders = Order.by_user(self.id).order('created_at DESC')

	    orders_return = Hash.new

	    orders.each do |order|	    	
	      orders_return[order.id] = order.format_with_store_for_web_serivce 
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

	# Function to get loyalty cards for a customer
	#
	# * *Args*    :
	#   - +page+ -> the pagination size
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def get_loyalty_cards(page=10)
		@page = page

		loyalty_cards = LoyaltyCard.by_user(self.id).order('created_at DESC')

	    loyalty_cards_return = Hash.new

	    loyalty_cards.each do |loyalty_card|
	      loyalty_cards_return[loyalty_card.id] = loyalty_card.format_for_web_serivce 
	    end
        		
	    loyalty_cards_return	
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

	# Function to redeem a deal
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def redeem_deal(deal)

        start_time = Time.at((deal.start_time.hour ) * 60 * 60 + deal.start_time.min * 60 + deal.start_time.sec)
        end_time = Time.at((deal.end_time.hour ) * 60 * 60 + deal.end_time.min * 60 + deal.end_time.sec)
        time_now = Time.at((Time.now.hour + 2) * 60 * 60 + Time.now.min * 60 + Time.now.sec)

		if (end_time >= time_now >= start_time)
			deals_user = DealUser.new
			deals_user.user_id = self
			deals_user.deal = deal
			deals_user.is_redeem = true
			deals_user.save

			return { "success" => "Deal Redeemed", "detail" =>  "Deal Redeemed" }
		else
			return { "error" => "Deal error", "detail" =>  "Deal could not be found" } 
		end

	end

	# Function to punch a loyatly card
	#
	# * *Args*    :
	#   - 
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def punch_loyalty_card(loyalty_card)
		loyalty_card.count += 1
        if loyalty_card.count == loyalty.win_count
        	loyalty_card.is_won = true
        end
         	loyalty_card.save
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

		Resque.enqueue(NewUserPinMailer, self.id, new_pin, self.email)

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