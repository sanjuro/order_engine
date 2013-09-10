class LoyaltyCard < ActiveRecord::Base

  attr_accessible :loyalty_id, :user_id, :count, :is_active, :is_won, :creatd_at, :updated_at

  belongs_to :loyalty
  belongs_to :customer, :foreign_key => "user_id", :class_name => "Customer"

  scope :by_user, lambda {|user_id| where("loyalty_cards.user_id = ?", user_id)} 
  scope :by_loyalty, lambda {|loyalty_id| where("loyalty_cards.loyalty_id = ?", loyalty_id)} 

  def format_for_web_serivce
    loyatly_card_return = Hash.new

    loyatly_card_return = { 
        "count" => self.count.to_s,
        "updated_at" => self.updated_at,
        "created_at" => self.created_at,
        "is_won" => self.is_won,
        "id" => self.id.to_s,
        "loyalty" => { 
            "name" => self.loyalty.name,
            "description" => self.loyalty.description,
            "win_count" => self.loyalty.win_count.to_s,
            "prize" => self.loyalty.prize,
            }      
    }
  end

end