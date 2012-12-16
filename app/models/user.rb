#
# Table name: users
#
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'devise'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :trackable, 
  #        :validatable

  # To facilitate username or email login
  attr_accessor :login

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :full_name, :username, :email, :password, :password_confirmation, :remember_me, :store_id,
                  :authentication_token, :first_name, :last_name, :mobile_number, :gender, :birthday, :user_pin,
                  :profileable_type

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :omniauthable,
  #        :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :profileable, :polymorphic => true

  has_many :access_grants

  has_and_belongs_to_many :stores, :join_table => 'users_stores'

  # before_create :create_client
  after_create :generate_authentication_token
  
  scope :recent_by_sign_in, order("users.last_sign_in_at") 

  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end  

  def self.find_for_token_authentication(authentication_token)
    access = AccessGrant.find_access(authentication_token)
    return access.user if access
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(user)
    Thread.current[:user] = user
  end  


  # Function to generate a new authentication token for the user
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def generate_authentication_token
      begin
        self.authentication_token = SecureRandom.hex
      end while self.class.exists?(authentication_token: authentication_token)
      self.save
  end
  
end