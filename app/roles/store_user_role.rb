# Module create the Store User role
#
# Author::    Shadley Wentzel

module StoreUserRole

	# Function to create a new order
	#
	# * *Args*    :
	#   - +order+ -> the order object
	#   - +status+ -> the status to change too
	#   - +time_to_ready+ -> the time in minutes for the order to be ready
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def update_order_state(order, status, time_to_ready)
		# create order
		order.time_to_ready = time_to_ready
		order.state = status
		order.save

		case status
		when 'store_received'
			previous_state = 'confirm'
			next_state = 'sent_store'
		when 'in_progress'
			previous_state = 'store_received'
			next_state = 'ready'
		when 'ready'
			previous_state = 'in_progress'
			next_state = 'collected'
		when 'collected'
			previous_state = 'collected'
			next_state = 'complete'
		end

        StateEvent.create({
          :previous_state => previous_state,
          :next_state => next_state,
          :name => 'order',
          :user_id => self.id,
          :stateful_id => order.id,
          :stateful_type => 'order'
        })

		order.format_for_web_serivce
	end

	# Function to authenticate a store user
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
	      false
	    end
	end


	# Function to set an order to cancelled
	#
	# * *Args*    :
	#   - +order+ -> the order to update
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def cancel_order(order)

        StateEvent.create({
          :previous_state => order.state,
          :next_state => '',
          :name => 'order',
          :user_id => self.id,
          :stateful_id => order.id,
          :stateful_type => 'order'
        })

		order.state = 'cancelled'
		order.save

		order.format_for_web_serivce
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