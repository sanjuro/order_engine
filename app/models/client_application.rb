class ClientApplication < ActiveRecord::Base

  attr_accessible :name

  has_many :access_grants

end