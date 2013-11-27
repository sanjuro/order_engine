# Class to model a payment profile
#
# Author::    Shadley Wentzel
class PaymentProfile < ActiveRecord::Base
  serialize :payment_data
  
  attr_accessible :unique_token, :payment_method_id, :payment_data, :is_active, :created_at

  belongs_to :customer, :foreign_key => "user_id", :class_name => "Customer"
  belongs_to :payment_method  

  before_create :generate_unique_token  

  scope :active,  where("payment_profiles.is_active = 1")
  scope :by_customer, lambda {|user_id| where("payment_profiles.user_id = ? AND payment_profiles.is_active = 1", user_id)}
  scope :by_unique_token, lambda {|unique_token| where("payment_profiles.unique_token = ?", unique_token)}

  # Function to generate a new authentication token for the user
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def generate_unique_token
    record = true
    while record
      random = SecureRandom.hex
      record = self.class.where(:unique_token => random).first
    end

    self.unique_token = random if self.unique_token.blank?
    self.unique_token
  end

end