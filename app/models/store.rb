# Class to model the store resource
#
# Author::    Shadley Wentzel
class Store < ActiveRecord::Base

	attr_accessible :store_name, :store_description, :email, :latitude, :longitude, 
  					:created_at, :completed_at, :updated_at

    has_and_belongs_to_many :taxons, :join_table => 'store_taxons'
    has_and_belongs_to_many :customers


end