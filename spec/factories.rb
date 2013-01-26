FactoryGirl.define do	
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
	  email                'test@gmail.com'
	  mobile_number        '0833908314'
	  birthday              Date.parse '1981-12-04'
	  user_pin      	   12345
  end
end