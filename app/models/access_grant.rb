class AccessGrant < ActiveRecord::Base

  attr_accessible :user_id, :code, :client_application_id, :authentication_token, :refresh_token, :authentication_token_expires_at

  belongs_to :user
  belongs_to :client_application  

  def self.find_access(authentication_token)
    where("authentication_token = ?", authentication_token).first
  end
 
  before_create :gen_tokens
  
  def self.prune!
    where(:created_at.lt => 3.days.ago).delete_all
  end
 
  def self.authenticate(code, client_application_id)
    where(:code => code, :client_application_id => client_application_id).first
  end
 
  def start_expiry_period!
    self.update_attribute(:authentication_token_expires_at, 360.days.from_now)
  end
 
  def redirect_uri_for(redirect_uri)
    if redirect_uri =~ /\?/
      redirect_uri + "&code=#{code}&response_type=code"
    else
      redirect_uri + "?code=#{code}&response_type=code"
    end
  end
 
  protected
  
  def gen_tokens
    self.code, self.refresh_token = SecureRandom.hex(8), SecureRandom.hex(8)
  end
 
end

