# Class to model the customer resource
#
# Author::    Shadley Wentzel
#
# == Schema Information
#
# Table name: customers
#
#  id                          :integer(4)      not null, primary key
#  full_name                  :string(255)
#  user_pin                   :string(255)
#  email                      :string(255)
#  mobile_number              :string(255)
#  gender                     :string(255)
#  encrypted_password         :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  user_id                    :integer(4)
#
require File.dirname(__FILE__) +  '/user.rb'

class Customer < User

  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :full_name, :user_pin, :email, :mobile_number, :gender, :encrypted_password, 
                  :remember_me, :provider, :uid, :user_attributes

  validates :full_name,  :email, :mobile_number, :presence => true

  has_one :user, :as => :role
  accepts_nested_attributes_for :user

  has_many :orders
  has_many :favourties
  has_and_belongs_to_many :stores

  # before_create :create_client
  # before_create :generate_user_pin
  
  # scope :recent_by_sign_in, order("users.last_sign_in_at")  
  # scope :by_store, lambda {|store| where("users.store_id = ?", store)} 
  
  # Function to generate a new user pin
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def genrate_user_pin(user_pin)
    salt = secure_hash("#{Time.now.utc}--#{user_pin}")
    self.encrypted_password = secure_hash("#{salt}--#{user_pin}")
    self.encrypted_password
    self.save
  end
    
end