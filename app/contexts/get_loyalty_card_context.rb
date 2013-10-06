# Context to retrieve a single loyalty card
#
# Author::    Shadley Wentzel

class GetLoyaltyCardContext
  attr_reader :loyalty_card_id

  def self.call(loyalty_card_id)
    GetLoyaltyCardContext.new(loyalty_card_id).call
  end

  def initialize(loyalty_card_id)
    @loyalty_card_id = loyalty_card_id
  end

  def call
    loyalty_card = LoyaltyCard.find(@loyalty_card_id)
    loyalty_card.format_for_web_serivce_with_stores
  end
end