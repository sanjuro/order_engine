class Orders < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'orders' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/orders/page/1?authentication_token=AXSSSSED2ASDASD6
    # curl -i -H "Accept: application/json" -X POST -d '{"order":{"unique_id":"kau0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "12345", "device_type":"blackberry", "line_items":{ "1": {"variant_id":"13","quantity":"1"}, "2":{"variant_id":"12","quantity":"1"}   }}}' http://127.0.0.1:9000/api/v1/orders?authentication_token=1b032cb31ad1f41e662238182ebbf456

    desc "Retrieve all orders"
    get "/" do      
      logger.info "Retrieved all orders"
      authenticated_user
      Order.all 
    end

    desc "Retrieve a specific order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    get "/:id" do 
      logger.info "Retrieveing Order with ID: #{params[:id]}"
      authenticated_user
      Order.find(params[:id])
    end
    
    desc "Creates a new order"
    post "/" do
      logger.info "Create new Order with params"
      authenticated_user
      p params
      NewCustomerOrderContext.call(current_user, params['order']) 
    end

    desc "Retrieve orders in a paginated form for a user"
    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      authenticated_user
      logger.info "Retrieved all orders for #{current_user.full_name}"
      GetOrdersContext.call(current_user, params[:page]) 
    end

    desc "Updates the status of an Order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
      requires :status, :type => String, :desc => "Order status."
      requires :time_to, :type => String, :desc => "Time to Order ready."
    end
    put "/:id/update_status" do 
      logger.info "Updating status of Order with ID: #{params[:id]}"
      authenticated_user
      order = Order.find(params[:id])
      UpdateOrderStatusContext.call(current_user, order, params[:status], time_to) 
    end
  end
  
end