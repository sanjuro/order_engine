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
require 'digest/sha2'

class Customer < User

  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :full_name, :user_pin, :email, :gender, :encrypted_password, 
                  :remember_me, :provider, :uid, :user_attributes, :first_name, :last_name, 
                  :mobile_number, :birthday, :user_pin

  validates :first_name, :last_name, :email, :mobile_number, :presence => true

  has_one :user, :as => :profileable
  accepts_nested_attributes_for :user

  has_many :orders
  has_many :favourties
  has_and_belongs_to_many :stores

  # before_create :create_client
  after_create :generate_user_pin, :create_full_name
  
  # scope :recent_by_sign_in, order("users.last_sign_in_at")  
  # scope :by_store, lambda {|store| where("users.store_id = ?", store)} 


  # Function to generate the full name for a new customer
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def create_full_name
    self.full_name = "#{first_name} #{self.last_name}"
    self.save
  end


  # Function to generate to create a new access grant
  #
  # * *Args*    :
  #   - +client_application_id+ -> the id of the client application
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def create_access_grant(client_application_id)
    access_grant = AccessGrant.new(
                                    :user_id => self.id,
                                    :client_application_id => client_application_id,
                                    :authentication_token => self.authentication_token,
                                    :authentication_token_expires_at => 360.days.from_now
                                  )
    access_grant.save
  end

  
  # Function to generate a new user pin
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def generate_user_pin
    self.user_pin =  Digest::MD5::hexdigest("#{self.user_pin}")
    self.save
  end
    
end