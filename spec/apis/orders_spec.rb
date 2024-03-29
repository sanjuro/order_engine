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

        it 'SHOULD return a 200 when an access token is provided to /api/v1/orders' do
          get '/api/v1/orders.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end

        context 'AND using pagination GET /api/v1/orders/page/:page' do

          it 'SHOULD return a 200 and the requested order' do
            get "/api/v1/orders/page/1?authentication_token=CXTTTTED2ASDBSD3"
            last_response.status.should == 200
            retrieved_order = JSON.parse(last_response.body)
          end

        end

      end

    end

    context "GET /api/v1/orders/by_customer" do

      context "GIVEN you want to retrieve all orders for a customer" do

        it 'should return a 401 when no acces token is supplied /api/v1/orders' do
          get "/api/v1/orders/by_customer.json"
          last_response.status.should == 401
        end

        it 'SHOULD return a 200' do      
           get "/api/v1/orders/by_customer.json?authentication_token=d1b01126294db97ad5588aa50ae90952"    
          last_response.status.should == 200
        end

        it 'SHOULD return orders for the user' do
          get "/api/v1/orders/by_customer.json?authentication_token=d1b01126294db97ad5588aa50ae90952"
          retrieved_orders = JSON.parse(last_response.body)
          retrieved_orders.count.should >= 1
        end      

        it 'SHOULD return store name for each order' do
          get "/api/v1/orders/by_customer.json?authentication_token=d1b01126294db97ad5588aa50ae90952"
          retrieved_orders = JSON.parse(last_response.body)
          order = retrieved_orders.first
          order["store_name"].empty?.should == false
        end  

        it 'SHOULD return store image for each order' do
          get "/api/v1/orders/by_customer.json?authentication_token=d1b01126294db97ad5588aa50ae90952"
          retrieved_orders = JSON.parse(last_response.body)
          order = retrieved_orders.first
          order["store_image"].empty?.should == false
        end  

      end
    end   

    context "GIVEN viewing a single order" do

        order = Order.find(1287)

        it 'should return a 200 and the requested order number' do
          get "/api/v1/orders/#{order.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["number"].should == order.number
        end

        it 'should return all associated line items' do
          get "/api/v1/orders/#{order.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["line_items"].count.should >= 1
        end

        it 'should return the shipping address if one is attached' do
          get "/api/v1/orders/#{order.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          retrieved_order = JSON.parse(last_response.body)
          retrieved_order["address"].count.should >= 1
        end
      end

    end

    # context "POST /api/v1/orders" do

    #   context "GIVEN we are creating an order" do

    #     before :each do        
    #       @order = FactoryGirl.build(:order)
    #       @request_payload = {
    #         order: {
    #           store_id: 1,
    #           special_instructions: "Poes",
    #           device_identifier: "1234",
    #           device_type: 'blackberry',
    #           line_items: {
    #                         "0" => { :variant_id => 1, :quantity => 5 }
    #                       }
    #         }
    #       }

    #       post '/api/v1/users/orders?authentication_token=CXTTTTED2ASDBSD3',  @request_payload.to_json
    #     end

    #     it "should retrieve status code of 200" do
    #       last_response.should == 201
    #     end

    #     it 'should add one order' do
    #       last_response.should change(Order, :count).by(1)
    #     end

    #     it 'should add one order' do
    #       order = Order.last
    #       order.line_items.count.should == 1
    #       order.line_items.first.variant.should == variant
    #       order.line_items.first.quantity.should == 5
    #     end

    #   end  

    # end  

    context "POST /api/v1/orders/:id/status" do

      context "GIVEN returning the status of a single order" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/status?authentication_token=CXTTTTED2ASDBSD4"
          
        end

        it 'SHOULD return a 200' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the status of the order' do
          last_response.body.empty?.should == false
        end
      end
    end  

    context "GET /api/v1/orders/:id/store_receive" do

      context "GIVEN moving an order to store_receive" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/store_receive?authentication_token=CXTTTTED2ASDBSD4&time_to_ready=15"
          p last_response.body
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of store_receive' do
          @retrieved_order['state'].should == 'store_received'
        end

      end
    end  

    context "GET /api/v1/orders/:id/in_progress" do

      context "GIVEN moving an order to in progress" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/in_progress?authentication_token=CXTTTTED2ASDBSD4&time_to_ready=15"
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of in_progress' do
          @retrieved_order['state'].should == 'in_progress'
        end

         it 'SHOULD return the order with the correct time to ready' do
          @retrieved_order['time_to_ready'].should == '15'
        end       
      end
    end  

    context "GET /api/v1/orders/:id/ready" do

      context "GIVEN moving an order to ready" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/ready?authentication_token=CXTTTTED2ASDBSD3"
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 200' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of ready' do
          @retrieved_order['state'].should == 'ready'
        end      
      end
    end   

    context "GET /api/v1/orders/:id/cancel" do

      context "GIVEN moving an order to cancelled" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/cancel?authentication_token=CXTTTTED2ASDBSD3"
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of cancelled' do
          @retrieved_order['state'].should == 'cancelled'
        end
             
      end
    end  

    context "GET /api/v1/orders/:id/collected" do

      context "GIVEN moving an order to collected" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/collected?authentication_token=CXTTTTED2ASDBSD3"
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of collected' do
          @retrieved_order['state'].should == 'collected'
        end
             
      end
    end 

    context "GET /api/v1/orders/:id/not_collected" do

      context "GIVEN moving an order to not_collected" do

        before :each do   
          @order = FactoryGirl.build(:order)
          post "/api/v1/orders/#{@order.id}/not_collected?authentication_token=CXTTTTED2ASDBSD3"
          @retrieved_order = JSON.parse(last_response.body)
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the order with the status of not_collected' do
          @retrieved_order['state'].should == 'not_collected'
        end
             
      end
    end 
end