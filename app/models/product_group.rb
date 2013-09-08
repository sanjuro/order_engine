class ProductGroup < ActiveRecord::Base

  	attr_accessible :id, :name

  	has_many :loyalties

end