# Class to model the store resource
#
# Author::    Shadley Wentzel

class Store < ActiveRecord::Base

  include Sunspot::ActiveRecord

	attr_accessible :store_name, :unique_id, :store_description, :address, :email, :latitude, :longitude, 
					        :manager_name, :manager_contact, :is_online, :created_at, :completed_at, :updated_at, 
                  :fanpage_id, :tag, :business_hours_attributes

  geocoded_by :address, :latitude => :latitude, :longitude => :longitude
  after_validation :geocode, :if => :address_changed?
  reverse_geocoded_by :latitude, :longitude
  after_validation :reverse_geocode 

  validates :store_name, :presence => true
  validates :latitude, :presence => true
  validates :longitude, :presence => true
  validates :manager_name, :presence => true

	has_many :business_hours
  has_many :orders
  
  has_many :devices, :as => :deviceable

  has_many :images, :as => :viewable, :order => :position

  has_and_belongs_to_many :tags, :join_table => 'stores_tags'

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
  scope :by_unique_ids, lambda {|unique_id| where("stores.unique_id IN (?)", unique_id)} 

  def store_icon
    self.images.first.attachment.url(:mini, false)
  end

  Sunspot.setup(Store) do
    text :store_name
    string :unique_id
    text :tag
    string :address
    location (:location) { Sunspot::Util::Coordinates.new(latitude, longitude) }
    # string(:location, :as => :location) { [lat,lng].join(",") }
  end


  def format_for_web_serivce
    store_return = Hash.new

    store_return = { 
            "address" => self.address,
            "can_deliver" => self.can_deliver,
            "created_at" => self.created_at,
            "email" => self.email,
            "fanpage_id" => self.fanpage_id,
            "id" => self.id,
            "is_online" => self.is_online,
            "latitude" => self.latitude,
            "longitude" => self.longitude,
            "manager_contact" => self.manager_contact,
            "manager_name" => self.manager_name,
            "store_description" => self.store_description,
            "store_name" => self.store_name,
            "telephone" => self.telephone,
            "unique_id" => self.unique_id,
            "updated_at" => self.updated_at,
            "url" => self.url,
            "store_image" => self.store_icon
            "business_hours" => self.business_hours,
    }
  end  

  def format_for_web_serivce_with_gps(latitude, longitude)
    store_return = Hash.new

    distance = self.distance_to([latitude, longitude], :km).round(2)

    store_return = { 
            "address" => self.address,
            "can_deliver" => self.can_deliver,
            "created_at" => self.created_at,
            "email" => self.email,
            "fanpage_id" => self.fanpage_id,
            "id" => self.id,
            "is_online" => self.is_online,
            "latitude" => self.latitude,
            "longitude" => self.longitude,
            "manager_contact" => self.manager_contact,
            "manager_name" => self.manager_name,
            "store_description" => self.store_description,
            "store_name" => self.store_name,
            "telephone" => self.telephone,
            "unique_id" => self.unique_id,
            "updated_at" => self.updated_at,
            "distance" => distance,
            "url" => self.url,
            "store_image" => self.store_icon
            "business_hours" => self.business_hours
    }
  end    
end