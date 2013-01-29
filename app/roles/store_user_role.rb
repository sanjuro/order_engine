# Module create the Store User role
#
# Author::    Shadley Wentzel

module StoreUserRole

	# Function to create a new order
	#
	# * *Args*    :
	#   - +order+ -> the order object
	#   - +status+ -> the status to change too
	# * *Returns* :
	#   - 
	# * *Raises* :
	#   - 
	#
	def update_order_state(order, status)
		# create order
		order.state = status
		order.save

		case status
		when 'in_progress'
			previous_state = 'sent_store'
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

		order
	end


	# Function to authenticate a store siser
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