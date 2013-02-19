require 'spec_helper'

describe StoreUsers do
  include Rack::Test::Methods

  def app
    StoreUsers
  end

  context "Authenticate a store user" do

    describe 'POST /api/v1/store_users/authenticate' do

      before :each do        
        user = FactoryGirl.build(:user)
        @request_payload = {
            authentication_token: "CXTTTTED2ASDBSD4",
            username: "kauai_user",
            password: "rad6hia",
        }

        post '/api/v1/store_users/authenticate', @request_payload
      end

      it 'should return a 201' do  
        last_response.status.should == 201
      end

      it 'should return the correct customer' do  
        retrieved_store_user = JSON.parse(last_response.body)
        retrieved_store_user["username"].should eql('kauai_user')
      end

      it 'should return the correct store name' do  
        retrieved_store_user = JSON.parse(last_response.body)
        retrieved_store_user["store_name"].should eql('Kauai - Greenmarket Square')
      end

    end

  end
  
end