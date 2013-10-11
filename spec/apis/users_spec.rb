require 'spec_helper'

describe Users do
  include Rack::Test::Methods

  def app
    Users
  end

    context "Viewing all users" do

      describe 'GET /api/v1/users' do
        it 'should return a 401 when no acces token is supplied /api/v1/users' do
          get '/api/v1/users'
          last_response.status.should == 401
        end
      end

      describe 'GET /api/v1/users' do
        it 'should return a 200 when an access token is provided to /api/v1/users' do
          get '/api/v1/users.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end
      end

      describe 'GET /api/v1/users/:id' do
        user = User.all.first
        it 'should return a 200 and the requested user' do
          get "/api/v1/users/#{user.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["full_name"].should == user.full_name
        end
      end

   end

  context "Create a new customer" do

    describe 'POST /api/v1/users/create_customer' do

      user = FactoryGirl.build(:user)

      it 'SHOULD add one user' do
        lambda {
          post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        }.should change(User, :count).by(1)       
        last_response.status.should eql(201)
      end

      it 'SHOULD throw an error if there is already an existing customer with an email' do
        user.email = 'shads6ter@gmail.com'
        lambda {
          post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        }.should_not change(User, :count).by(1)       
        last_response.status.should eql(400)
      end

      it 'SHOULD set has the users pin' do
        post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        retrieved_user = JSON.parse(last_response.body)  
        retrieved_user['user_pin'].should eq(Digest::MD5::hexdigest("11111"))
      end

      it 'SHOULD set encrypted password to users pin' do
        post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        retrieved_user = JSON.parse(last_response.body)  
        retrieved_user['user_pin'].should eq(retrieved_user['encrypted_password'])
      end

      it 'SHOULD set the username to the email' do
        post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        retrieved_user = JSON.parse(last_response.body)  
        retrieved_user['useranme'].should eq(retrieved_user['email'])
      end

    end

    describe 'after creating, the new user' do

      before do
        @user = User.last
      end

      it 'SHOULD have the a new authentication_token token and the correct first_name and last_name' do
        @user.authentication_token.should_not be_empty
        @user.first_name.should == 'Test'
        @user.last_name.should == 'Customer'
      end

      it 'SHOULD add one access grant' do
        @user.access_grants.count.should == 1
      end
    end
  end

  context "Sign in via a social login" do

    describe 'POST /api/v1/users/social_signin' do

      user = FactoryGirl.build(:user)

      email = Hash.new
      email = { :email => user.email }
     
      it 'SHOULD sign the user in' do
        post '/api/v1/users/social_signin?authentication_token=CXTTTTED2ASDBSD4', email.to_json
        retrieved_user = JSON.parse(last_response.body)  
        retrieved_user['email'].should eq(user['email'])
      end

      it 'SHOULD not sign the user in' do
        email = { :email => "asdsd2Gmail.com" }
        post '/api/v1/users/social_signin?authentication_token=CXTTTTED2ASDBSD4', email.to_json
        retrieved_user = JSON.parse(last_response.body)  
        retrieved_user['email'].should eq(nil)
      end

    end

  end

end