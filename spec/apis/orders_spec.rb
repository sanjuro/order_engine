require 'spec_helper'

describe Orders do
  include Rack::Test::Methods

  def app
    Orders
  end

  describe "GET /api/v1/orders'", :type => :api do

    context "GIVEN viewing all orders" do

      context "AND when not authorized" do  
        
        it 'should return a 401 when no acces token is supplied /api/v1/orders' do
          get '/api/v1/orders'
          last_response.status.should == 401
        end

      end

      context "AND when authorized" do 

        it 'should return a 200 when an access token is provided to /api/v1/orders' do
          get '/api/v1/orders.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end

        context 'AND using pagination GET /api/v1/orders/page/:page' do

          it 'should return a 200 and the requested order' do
            get "/api/v1/orders/page/1?authentication_token=CXTTTTED2ASDBSD3"
            last_response.status.should == 200
            retrieved_order = JSON.parse(last_response.body)
          end

        end

      end

    end

    context "GIVEN viewing a single order" do

        order = Order.all.first
        it 'should return a 200 and the requested order' do
          get "/api/v1/orders/#{order.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["number"].should == order.number
        end
      end

    end

    context "POST /api/v1/orders" do

      context "GIVEN we are creating an order" do

        before :each do        
          @order = FactoryGirl.build(:order)
          @request_payload = {
            order: {
              store_id: 1,
              special_instructions: "Poes",
              device_identifier: "1234",
              device_type: 'blackberry',
              line_items: {
                            "0" => { :variant_id => 1, :quantity => 5 }
                          }
            }
          }

          post '/api/v1/users/orders?authentication_token=CXTTTTED2ASDBSD3',  @request_payload.to_json
        end

        it "should retrieve status code of 200" do
          last_response.should == 201
        end

        it 'should add one order' do
          last_response.should change(Order, :count).by(1)
        end

        it 'should add one order' do
          order = Order.last
          order.line_items.count.should == 1
          order.line_items.first.variant.should == variant
          order.line_items.first.quantity.should == 5
        end

      end  

    end  

    context "GET /api/v1/orders/:id/update_status" do

      context "GIVEN updating the status a single order" do

        before :each do   
          @order = FactoryGirl.build(:order)
          get "/api/v1/orders/#{@order.id}/update_status?authentication_token=CXTTTTED2ASDBSD3&status=in_progress"
        end

        it 'should return a 200' do          
          last_response.status.should == 200
        end

        it 'should update the status of the order' do
          retrieved_order = Order.find(@order.id)
          retrieved_order.state.should == 'in_progress'
        end
      end
    end  
end