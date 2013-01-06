require 'spec_helper'

describe Orders do
  include Rack::Test::Methods

  def app
    Orders
  end

    context "viewing all orders" do
      describe 'GET /api/v1/orders' do
        it 'should return a 401 when no acces token is supplied /api/v1/orders' do
          get '/api/v1/orders'
          last_response.status.should == 401
        end
      end

      describe 'GET /api/v1/orders' do
        it 'should return a 200 when an access token is provided to /api/v1/orders' do
          get '/api/v1/orders.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end
      end

      describe 'GET /api/v1/orders/:id' do
        order = Order.all.first
        it 'should return a 200 and the requested order' do
          get "/api/v1/orders/#{order.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["number"].should == order.number
        end
      end

      describe 'GET /api/v1/orders/page/:page' do
        it 'should return a 200 and the requested order' do
          get "/api/v1/orders/page/1?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
        end
      end
    end

    context "creating a new order" do

      describe 'POST /api/v1/orders' do
        
        order = FactoryGirl.build(:order)

        it 'should add one order' do
          lambda {
            post '/api/v1/users/orders?authentication_token=CXTTTTED2ASDBSD3', order.to_json
          }.should change(Order, :count).by(1)
          last_response.status.should eql(201)
        end

      end  

    end  
  
end