require 'spec_helper'

describe Customers do
  include Rack::Test::Methods

  def app
    Customers
  end

  context "Authenticate a customer" do

    describe 'POST /api/v1/customers/authenticate' do

      before :each do        
        user = FactoryGirl.build(:user)
        @request_payload = {
            authentication_token: "CXTTTTED2ASDBSD4",
            username: "sanjuro",
            password: "rad6hia",
        }

        post '/api/v1/customers/authenticate', @request_payload
      end

      it 'should return a 201' do  
        last_response.status.should == 201
      end

      it 'should return the correct customer' do  
        retrieved_customer = JSON.parse(last_response.body)
        retrieved_customer["username"].should eql('sanjuro')
      end

    end

  end
  
end