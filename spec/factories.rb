FactoryGirl.define do	
  factory :customer do
	  first_name           'Shadley'
	  last_name            'Wentzel'
	  mobile_number        '0833908314'
	  birthday              Date.parse '1981-12-04'
	  user_pin      	    "$2a$10$x/ZlQum89iAyYDUTQ5kxSOzijBptIZJwta3fEHituZQKGm9DR2D4q"
	  authentication_token  "AXSSSSED2ASDASD1"
  end

  factory :order do
	id 					1
	number              'R12345234'
	store_id            '1'
	user_id             '1'
	item_total          99.00
	total               99.00
	state      		   'sent_store'
  end

  factory :variant do
	  product_id           1
	  sku                  260
	  price                99.00
	  position             10
	  is_master      	   1
  end

  factory :user do
	  first_name           'Test'
	  last_name            'Customer'
	  email                'shadley2@personera.com'
	  mobile_number        '0833908314'
	  birthday              Date.parse '1981-12-04'
	  user_pin      	    11111
  end
end