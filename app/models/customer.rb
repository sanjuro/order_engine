#
# Table name: users
#
#  email      :string(255)
#  password   :string(255)
#  created_at :datetime
#  updated_at :datetime
#
class Customer < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :omniauthable,
  #        :recoverable, :rememberable, :trackable, :validatable

  # To facilitate username or email login
        
  # Setup accessible (or protected) attributes for your model
  attr_accessible :id, :full_name, :user_pin, :email, :mobile_number, :encrypted_password, 
                  :remember_me, :provider, :uid, :access_token
  
  validates :full_name,  :presence => true
  validates :email,  :presence => true
  validates :mobile_number,  :presence => true

  has_many :orders
  has_and_belongs_to_many :stores

  # before_create :create_client
  # before_create :generate_user_pin
  
  scope :recent_by_sign_in, order("customers.last_sign_in_at")  
  scope :by_store, lambda {|store| where("customers.store_id = ?", store)} 
  
  # Function to generate a new user pin
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def geenrate_user_pin(user_pin)
    salt = secure_hash("#{Time.now.utc}--#{user_pin}")
    self.encrypted_password = secure_hash("#{salt}--#{user_pin}")
    self.encrypted_password
    self.save
  end

  def self.current
    Thread.current[:user]
  end
  
  def self.current=(customer)
    Thread.current[:user] = user
  end

  def self.new_with_session(params, session)
    # super.tap do |user|
    #   if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
    #     user.email = data["email"] if user.email.blank?
    #   end
    # end
  end
  
  # Overrides the devise method find_for_authentication
  # Allow users to Sign In using their username or email address
  def self.find_for_authentication(conditions)
    login = conditions.delete(:login)
    where(conditions).where(["username = :value OR email = :value", { :value => login }]).first
  end
  
end