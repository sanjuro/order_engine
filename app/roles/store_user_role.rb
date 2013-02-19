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

			# send pusher notification for mobi site
	      	Pusher.app_id = '37591'
	      	Pusher.key = 'be3c39c1555da94702ec'
	      	Pusher.secret = 'deae8cae47a1c88942e1'
	      	Pusher['order'].trigger('in_progress_event', {:user_id => "#{order.customer.id}",:message => "Your order: #{order.number}is being cooked up at #{order.store.store_name} and will be ready in #{time_to_ready} minutes."})
		when 'ready'
			previous_state = 'in_progress'
			next_state = 'collected'

			# send pusher notification for mobi site
	      	Pusher.app_id = '37591'
	      	Pusher.key = 'be3c39c1555da94702ec'
	      	Pusher.secret = 'deae8cae47a1c88942e1'
	      	Pusher['order'].trigger('ready_event', {:user_id => "#{order.customer.id}",:message => "Your order: #{order.number} is ready for collection at #{order.store.store_name}. Please contact the store at #{order.store.manager_contact}, if there is a problem with your order."})

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

		previous_state = order.state

		order.state = 'cancelled'
		order.save

		# send pusher notification for mobi site
      	Pusher.app_id = '37591'
      	Pusher.key = 'be3c39c1555da94702ec'
      	Pusher.secret = 'deae8cae47a1c88942e1'
      	Pusher['order'].trigger('cancel_event', {:user_id => "#{order.customer.id}",:message => "Your order: #{order.number} was cancelled at #{order.store.store_name}. Please contact the store at #{order.store.manager_contact}, for further information."})
		
        StateEvent.create({
          :previous_state => previous_state,
          :next_state => '',
          :name => 'order',
          :user_id => self.id,
          :stateful_id => order.id,
          :stateful_type => 'order'
        })

		order.format_for_web_serivce
	end
	  
	def valid_password?(password)
	    return false if encrypted_password.blank?
	    # extract salt from encryped password
	    @user_password = BCrypt::Password.new(encrypted_password)	   
	    if @user_password == password
	      true
	    else
	      false
	    end
	end	
end