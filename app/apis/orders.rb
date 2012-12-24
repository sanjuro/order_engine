class Orders < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'orders' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/orders.json?page=1&authentication_token=CXTTTTED2ASDBSD3

    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      authenticated_user
      logger.info "Retrieved all orders for #{current_user.full_name}"
      GetOrdersContext.call(current_user, params[:page]) 
    end
    
    params do
      requires :id, :type => Integer, :desc => "Order id."
    end
    get "/:id" do 
      Order.find(params['id'])
    end
    
    post "/" do
      logger.info "Create new Order"
      order = Order.create(params['order'])
      # NewCustomerOrderContext.call(current_user, @order) 
    end
  end
  
end