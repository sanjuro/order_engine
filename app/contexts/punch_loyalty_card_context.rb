# Context to punch a loyatly card
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search_gps?query=kauai&latitude=-33.864809&longitude=18.570908
# curl -i -X POST -d'{"query_term": "", "latitude": "-33.899261", "longitude": "18.593347", "page":""}' 'http://127.0.0.1:9000/api/v1/stores/search'
# curl -i -X POST -d'{"query_term": "", "latitude": "-33.89421341009438", "longitude": "18.59125812537968"}' 'http://127.0.0.1:9000/api/v1/stores/search'
#
# curl -i -X POST -d '{"query_term": "", "latitude": "-33.89418256469071", "longitude": "18.591281594708562", "page":2}' 'http://107.22.211.58:9000/api/v1/stores/search' -v
# curl -i -X POST -d '{"query_term": "", "latitude": "-33.89421341009438", "longitude": "18.59125812537968"}' 'http://107.22.211.58:9000/api/v1/stores/search'
# Author::    Shadley Wentzel

class PunchLoyaltyCardContext
  attr_reader :user,:loyalty_card_id

  def self.call(user,loyalty_card_id)
    PunchLoyaltyCardContext.new(user,loyalty_card_id).call
  end

  def initialize(user_id,loyalty_card_id)
    @user.extend CustomerRole
    @loyalty_card_id = loyalty_card_id
  end

  def call
    loyalty_card = LoyaltyCard.find(@loyalty_card_id)
    @user.punch_loyalty_card(@loyalty_card)
  end
end
