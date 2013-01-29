# Class to model the store resource
#
# Author::    Shadley Wentzel

class Store < ActiveRecord::Base

  include Sunspot::ActiveRecord

	attr_accessible :store_name, :unique_id, :store_description, :address, :email, :latitude, :longitude, 
					        :manager_name, :manager_contact, :is_online, :created_at, :completed_at, :updated_at, 
                  :fanpage_id, :business_hours_attributes

  geocoded_by :address, :latitude => :latitude, :longitude => :longitude
  after_validation :geocode, :if => :address_changed?
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode 

  validates :store_name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  validates :manager_name, :presence => true

	has_many :business_hours
  
  has_many :devices, :as => :deviceable

  has_and_belongs_to_many :customers,
    :join_table => 'users_stores',
    :class_name => "User",
    :conditions => { :profileable_type => 'customer' },
    :order => 'created_at ASC'

  has_and_belongs_to_many :store_users,
    :join_table => 'users_stores',
    :class_name => "User",
    :conditions => { :profileable_type => 'store_user' },
    :order => 'created_at ASC'

  has_and_belongs_to_many :taxons, :join_table => 'stores_taxons'

  accepts_nested_attributes_for :business_hours

  scope :by_fanpage_id, lambda {|fanpage_id| where("stores.fanpage_id = ?", fanpage_id)} 
  scope :by_unique_id, lambda {|unique_id| where("stores.unique_id = ?", unique_id)} 

  Sunspot.setup(Store) do
    text :store_name
    string :unique_id
    string :address
    location (:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
  end

end