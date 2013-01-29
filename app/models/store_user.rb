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
require 'bcrypt'

class StoreUser < User

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :full_name, :username, :email, :password, :password_confirmation, :remember_me,
                  :authentication_token, :first_name, :last_name, :mobile_number, :gender, :birthday, :user_pin,
                  :profileable_type, :encrypted_password


  validates :email, :presence => true

  has_one :user, :as => :profileable
  accepts_nested_attributes_for :user

  has_and_belongs_to_many :stores

  # before_create :create_client
  # before_create :generate_user_pin
  
  # scope :by_store, lambda {|store| where("users.store_id = ?", store)} 
  scope :by_username,lambda {|username| where("users.username = ?", username)} 
  
end