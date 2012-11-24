class Orders < Grape::API
  
  version 'v1', :using => :path
  format :json

  helpers do
    def logger
      API.logger
    end
  end
  
  resource 'orders' do
    get "/" do
      logger.info "Retrieved all orders"
      Order.all
    end
    
    get "/:id" do 
      Order.find(params['id'])
    end
    
    post "/create" do
      # Order.create(params['order'])
      NewCustomerOrderContext.call(current_user, @order) 
    end
  end
  
end