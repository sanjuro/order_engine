require 'spec_helper'

describe Orders do
  include Rack::Test::Methods

  def app
    Orders
  end

    context "viewing all orders by user" do
      describe 'GET /api/v1/orders' do
        it 'should return a 401 when no acces token is supplied /api/v1/orders' do
          get '/api/v1/orders'
          last_response.status.should == 401
        end
      end

      describe 'GET /api/v1/orders' do
        it 'should return a 200 when an access token is provided to /api/v1/orders' do
          get '/api/v1/orders.json?access_token=AXSSSSED2ASDASD1'
          last_response.status.should == 200
        end
      end

      describe 'GET /api/v1/orders/:id' do
        order = Order.all.first
        it 'should return a 200 and the requested order' do
          get "/api/v1/orders/#{order.id}.json?access_token=AXSSSSED2ASDASD1"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["number"].should == order.number
        end
      end
    end

    context "creating a new user" do
      describe 'POST /api/v1/orders' do
        order = FactoryGirl.build(:order)

        it 'should return a 201 when an access token is provided to /api/v1/orders' do
          post '/api/v1/orders.json?access_token=AXSSSSED2ASDASD1', :order => order
          last_response.status.should eql(201)
          last_response.body.should eql(order.to_json)
        end
      end  

    end  
  
end