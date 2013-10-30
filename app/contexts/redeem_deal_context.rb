# Context to punch a loyatly card
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/deals/1/redeem?authentication_token=2d3c4c50602fbd3edce50fe62bace6e0
# Author::    Shadley Wentzel

class RedeemDealContext
  attr_reader :user,:deal_id

  def self.call(user, deal_id)
    RedeemDealContext.new(user,deal_id).call
  end

  def initialize(user, deal_id)
    @user, @deal_id = user, deal_id
    @user.extend CustomerRole
  end

  def call
    deal = Deal.find(@deal_id)
    @user.redeem_deal(deal)
  end
end
