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
            authentication_token: "CXTTTTED2ASDBSD3",
            email: "shadley2@personera.com",
            password: "rad6hia",
        }

        post '/api/v1/customers/authenticate', @request_payload
        
      end

      it 'should return a 201' do  
        last_response.status.should == 201
      end

      it 'should return the correct username' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["username"].should eql('sanjuro')
      end

      it 'should return the correct first_name' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["first_name"].should eql('shadley')
      end

      it 'should return the correct last_name' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["last_name"].should eql('wentzel')
      end

      it 'should return the correct email' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["email"].should eql('shadley2@personera.com')
      end

      it 'should return the correct mobile number' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["mobile_number"].should eql('0833908314')
      end

    end

  end
  
end