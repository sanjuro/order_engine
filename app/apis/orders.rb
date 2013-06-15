class Orders < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'orders' do

    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/orders/page/1?authentication_token=17298c88ae1a2998ebb4c4ae6ecd086d
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/orders/1?authentication_token=b5a27178456753ba773d83666d276631 -v 
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD4", "time_to_ready": "15", "store_order_number": "6666"}' http://107.22.211.58:9000/api/v1/orders/1537/in_progress -v 
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD4", "time_to_ready": "15", "store_order_number": "6666"}' http://107.22.211.58:9000/api/v1/orders/1537/ready -v 
    # curl -i -X POST -d '{"authentication_token":"d1b01126294db97ad5588aa50ae90952","order":{"unique_id":"spu0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "0D22FA0B-6682-43D5-8141-D70D90A8874E", "device_type": "ios", "store_order_number": "6465", "line_items":[{"variant_id":"1","quantity":"1","special_instructions": "test"}]}}' http://107.22.211.58:9000/api/v1/orders -v
    # curl -i -X POST -d '{"authentication_token":"b5a27178456753ba773d83666d276631","order":{"unique_id":"spu0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "DEfe123123", "device_type": "blackberry", "store_order_number": "6465", "line_items":[{"variant_id":"1","quantity":"1","special_instructions": "test"}]}}' http://127.0.0.1:9000/api/v1/orders -v
    # curl -i -X POST -d '{"authentication_token":"b5a27178456753ba773d83666d276631","order":{"unique_id":"spu0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "DEfe123123", "device_type": "blackberry", "line_items":{"variant_id":"1","quantity":"1","special_instructions": "test"}}}' http://127.0.0.1:9000/api/v1/orders -v

    desc "Retrieve all orders"
    get "/" do  
      logger.info "Retrieved all orders"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      orders_return = Array.new

      Order.all .each do |order|
        orders_return << order.format_for_web_serivce 
      end

      orders_return
    end

    desc "Retrieve a specific order"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    get "/:id" do 
      logger.info "Retrieveing Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      order.format_for_web_serivce
    end
    
    desc "Creates a new order"
    post "/" do
      logger.info "Create new Order with params"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      logger.info "Order Data: #{params}"
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

      if !params[:store_order_number].nil?
        order.store_order_number = params[:store_order_number]
        order.save!
      end

      if !order.device_type.eql?('web')
        order.time_to_ready = params[:time_to_ready]
        order.save!
        
        if !order.device_type.eql?('ios')
        order.send_in_progress_nofitication 
        else
          
          if order.store_order_number.nil?
            order_number = order.number
          else
            order_number = order.store_order_number
          end

          device = Device.find_by_device_identifier(order.device_identifier).first

          message = Hash.new

          message[:order_id] = order.id
          message[:msg] = "Your order: #{store_order_number} has been received and will be ready in #{order.time_to_ready} minutes."
          message[:updated_at] = order.updated_at
          message[:store_order_number] = order.store_order_number
          message[:state] = order.state
          message[:time_to_ready] = order.time_to_ready

          Notification.adapter = 'ios'

          Notification.send(device.device_token, message)
        end
      end

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
     
      if !order.device_type.eql?('web')
         order.send_ready_nofitication 
      end

      UpdateOrderReadyContext.call(current_user, order) 
    end

    desc "Updates the status of an Order to collected"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/collected" do 
      logger.info "Updating status to collected of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      UpdateOrderCollectedContext.call(current_user, order) 
    end

    desc "Updates the status of an Order to not collected"
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    post "/:id/not_collected" do 
      logger.info "Updating status to collected of Order with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      order = Order.find(params[:id])
      NotCollectedOrderContext.call(current_user, order) 
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