FactoryGirl.define do
  factory :order do
	  number               'R12345234'
	  store_id             '1'
	  user_id             '1'
	  item_total           99.00
	  total                99.00
	  state      		   'complete'
  end
end
