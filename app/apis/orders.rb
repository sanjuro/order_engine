class Orders < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'orders' do

    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/orders/?authentication_token=CXTTTTED2ASDBSD4
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD3", "time_to_ready": "15"}' http://localhost:9000/api/v1/orders/1/store_receive
    # curl -i -X POST -d '{"authentication_token":"54ec660cd621f87dcc9a76c0a33285d1","order":{"unique_id":"kau0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "DEfe123123", "device_type": "blackberry", "line_items":[{"variant_id":"11","quantity":"1"}]}}' http://107.22.211.58:9000/api/v1/orders -v
    # curl -i -X POST -d '{"authentication_token":"b5a27178456753ba773d83666d276631","order":{"unique_id":"kau0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "DEfe123123", "device_type": "blackberry", "line_items":[{"variant_id":"11","quantity":"1"}]}}' http://127.0.0.1:9000/api/v1/orders -v

    desc "Retrieve all orders"
    get "/" do  
      logger.info "Retrieved all orders"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      Order.all 
    end

    desc "Retrieve a specific order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    get "/:id" do 
      logger.info "Retrieveing Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      Order.find(params[:id])
    end
    
    desc "Creates a new order"
    post "/" do
      logger.info "Create new Order with params"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      logger.info "Order Data: #{params['order']}"
      NewCustomerOrderContext.call(current_user, params['order']) 
    end

    desc "Retrieve orders in a paginated form for a user"
    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      logger.info "Retrieved all orders"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      GetOrdersContext.call(current_user, params[:page]) 
    end

    desc "Returns status of an order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/status" do 
      logger.info "Returning status of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      orders_return = Hash.new

      orders_return = { 
         "state" => order.state
      }
    end

    desc "Sets an order to store received"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/store_receive" do 
      logger.info "Store received Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      UpdateOrderStoreReceiveContext.call(current_user, order) 
    end

    desc "Updates the status of an Order to in_progress"
    params do
      requires :id, :type => Integer, :desc => "Order id."
      requires :time_to_ready, :type => String, :desc => "Time to Order is ready."
    end
    post "/:id/in_progress" do 
      logger.info "Updating status to in_progress of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      UpdateOrderInProgressContext.call(current_user, order, params[:time_to_ready]) 
    end

    desc "Updates the status of an Order to ready"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/ready" do 
      logger.info "Updating status to ready of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      UpdateOrderReadyContext.call(current_user, order) 
    end

    desc "Cancels an order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/cancel" do 
      logger.info "Cancelling of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      CancelOrderContext.call(current_user, order) 
    end
  end
  
end