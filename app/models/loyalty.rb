class Loyalty < ActiveRecord::Base

  attr_accessible :name, :description, :prize, :win_count, :tag, :is_active

  belongs_to :store_group
  belongs_to :product_group
  
end