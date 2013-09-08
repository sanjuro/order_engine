# Context to all loyalty cards for a customer
#
# Author::    Shadley Wentzel

class GetLoyaltyCardsForCustomerCostContext
  attr_reader :user

  def self.call(user)
    GetLoyaltyCardsForCustomerCostContext.new(user).call
  end

  def initialize(user)
    @user = user
    @user.extend CustomerRole
  end

  def call
    @user.get_loyalty_cards(10)
  end
end