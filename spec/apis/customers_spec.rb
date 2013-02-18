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
            authentication_token: "AXSSSSED2ASDASD1",
            email: "poes@gmail.com",
            pin: "11111",
        }

        post '/api/v1/customers/authenticate', @request_payload
        
      end

      it 'should return a 201' do  
        last_response.status.should == 201
      end

      it 'should return the correct username' do  
        @retrieved_customer = JSON.parse(last_response.body)
        @retrieved_customer["username"].should eql('shadley')
      end

    end

  end

  context "Updating a customer" do

    describe 'POST /api/v1/customers/update' do

      before :each do   
        @user = FactoryGirl.build(:user)
        @request_payload = {
          user: {
            first_name: "Poes",
            last_name: "Poes",
            email: "poes@gmail.com",
            mobile_number: "1234",
            user_pin: "11111"
          }
        }
        post "/api/v1/customers/update?authentication_token=AXSSSSED2ASDASD1",  @request_payload.to_json
        @retrieved_user = JSON.parse(last_response.body)
      end

      it 'SHOULD return a 201' do          
        last_response.status.should == 201
      end

      it 'SHOULD return the user with the correct first name updated' do
        @retrieved_user['first_name'].should == 'Poes'
      end  

      it 'SHOULD return the user with the correct last name updated' do
        @retrieved_user['first_name'].should == 'Poes'
      end  

      it 'SHOULD return the user with the correct email updated' do
        @retrieved_user['email'].should == 'poes@gmail.com'
      end 

      it 'SHOULD return the user with the correct user pin' do
        @retrieved_user['user_pin'].should == Digest::MD5::hexdigest("11111")
      end 

    end
  end  

  context "Resetting a customer pin" do

    describe 'POST /api/v1/customers/reset_pin' do

      before :each do   
        @user = FactoryGirl.build(:user)
        @request_payload = {
          email: 'customer@gmail.com'
        }
        post "/api/v1/customers/reset_pin?authentication_token=CXTTTTED2ASDBSD4",  @request_payload.to_json
      end

      it 'SHOULD return a 201' do          
        last_response.status.should == 201
      end

    end
  end
end