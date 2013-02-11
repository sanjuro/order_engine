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

      it 'should add one user' do
        lambda {
          post '/api/v1/users/create_customer.json?authentication_token=CXTTTTED2ASDBSD3', user.to_json
        }.should change(User, :count).by(1)       
        last_response.status.should eql(201)
      end

    end

    describe 'after creating, the new user' do

      before do
        @user = User.last
      end

      it 'should have the a new authentication_token token and the correct first_name and last_name' do
        @user.authentication_token.should_not be_empty
        @user.first_name.should == 'Test'
        @user.last_name.should == 'Customer'
      end

      it 'should add one access grant' do
        @user.access_grants.count.should == 1
      end
    end
  end

  end
end