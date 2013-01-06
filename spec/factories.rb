FactoryGirl.define do
  factory :order do
	  number               'R12345234'
	  store_id             '1'
	  user_id              '1'
	  item_total           99.00
	  total                99.00
	  state      		   'complete'
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