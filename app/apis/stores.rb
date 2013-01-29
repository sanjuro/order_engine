class Stores < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'stores' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/1/?authentication_token=CXTTTTED2ASDBSD3
 
    desc "Retrieve all stores"
    get "/" do
      logger.info "Retrieved all stores"
      Store.all 
    end

    desc "Retrieve all stores in a paginated form"
    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      logger.info "Retrieved all stores paginated"
      @page = params[:page].to_i||30
      Store.page(@page)
    end

    desc "Search Stores"
    params do
      requires :query, :type => String, :desc => "Search query."
    end
    get "/search" do
      logger.info "Searching all Stores for Term: #{params[:query]}"
      SearchStoresContext.call(params[:query], params[:page])
    end
    
    desc "Retrieve store by fanpage"
    params do
      requires :fanpage_id, :type => Integer, :desc => "Fanpage id."
    end
    get "/by_fanpage" do
      logger.info "Retrieved all Store with Fanpage ID: #{params[:fanpage_id]}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 
      store = Store.by_fanpage_id(params[:fanpage_id])
    end

    desc "Retrieve store by unique id"
    params do
      requires :unique_id, :type => String, :desc => "Unique ID"
    end
    get "/by_unique_id" do
      logger.info "Retrieved Store with Unique ID: #{params['unique_id']}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 
      store = Store.by_unique_id(params[:unique_id]).first
    end

    desc "Retrieve a specific store"
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id" do 
      logger.info "Showing Store with ID: #{params[:id]}"
      RetrieveStoreContext.call(params[:id])
    end
    
    desc "Returns taxons for a store."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id/taxons" do
      logger.info "Retrieved all taxons for Store with ID: #{params['id']}"
      store = Store.find(params[:id])
      store.taxons
    end

    desc "Swtich a store on."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id/online" do
      logger.info "Switched on Store with ID: #{params['id']}"
      authenticated_user
      store = Store.find(params[:id])
      store.update_attributes(:is_online => true)
      store
    end

    desc "Swtich a store off."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id/offline" do
      logger.info "Switched off Store with ID: #{params['id']}"
      authenticated_user
      store = Store.find(params[:id])
      store.update_attributes(:is_online => false)
      store
    end

    desc "Get new orders for store."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id/new_orders" do
      logger.info "Retrieved all new orders for Store with ID: #{params['id']}"
      authenticated_user
      store = Store.find(params[:id])
      GetNewStoreOrdersContext.(store)
    end
  end
  
end