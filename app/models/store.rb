# Class to model the store resource
#
# Author::    Shadley Wentzel

class Store < ActiveRecord::Base

	attr_accessible :store_name, :store_description, :address, :email, :latitude, :longitude, 
					:manager_name, :manager_contact, :created_at, :completed_at, :updated_at, 
                    :fanpage_id, :business_hours_attributes

    validates :store_name, :presence => true
    validates :latitude, :presence => true
    validates :longitude, :presence => true
    validates :manager_name, :presence => true

  	has_many :business_hours

    has_and_belongs_to_many :taxons, :join_table => 'stores_taxons'

    accepts_nested_attributes_for :business_hours

    after_validation :geocode

end