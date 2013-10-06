require 'spec_helper'

describe LoyaltyCards do
  include Rack::Test::Methods

  def app
    LoyaltyCards
  end

  context "viewing a single loyalty card" do

    describe 'GET /api/v1/loyalty_cards/:id' do
	    loyalty_card = LoyaltyCard.all.first	   
	    it 'should return a 200 and the requested loyalty_card' do
	      get "/api/v1/loyalty_cards/#{loyalty_card.id}.json?authentication_token=CXTTTTED2ASDBSD3"
	      last_response.status.should == 200
	      retrieved_loyalty_card = JSON.parse(last_response.body)
	      retrieved_loyalty_card["id"].should == loyalty_card.id.to_s
	    end
	end

  end

end