class Stores < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'stores' do

    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/stores/1/new_orders?authentication_token=AXSSSSED2ASDASD2
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/stores/search/thai
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/stores/featured
    # curl -v -H 'Accept: application/json' http://127.0.0.1:9000/api/v1/stores/53/new_orders?authentication_token=lb714q329neb1628m107a211an1176bz
    # curl -v -H 'Accept: application/json' -X POST -d '{"authentication_token": "AXSSSSED2ASDASD2"}' http://127.0.0.1:9000/api/v1/stores/new_orders -v
    # curl -v -H 'Accept: application/json' -X POST -d '{"authentication_token": "AXSSSSED2ASDASD2",}' http://107.22.211.58:9000/api/v1/orders/1/cancel
    # curl -H 'Accept: application/json' -X POST -d '{ "query_term": "", "page":"1", "latitude": "-33.97972", "longitude": "18.46325"}' 'http://107.22.211.58:9000/api/v1/stores/search' -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/stores/1/orders_for_today?state=in_progress&authentication_token=CXTTTTED2ASDBSD3 -v
    # curl -i -X POST -d '{"store_ids":["spu0000001","sim0000001"]}' 'http://107.22.211.58:9000/api/v1/stores/by_store_ids' -v

    desc "Retrieve all stores"
    get "/" do
      logger.info "Retrieved all stores"      
      stores_return = Array.new
      Store.all.each do |store|
        if store.id != 15
          stores_return << store.format_for_web_serivce
        end
      end
      stores_return
    end

    desc "Retrieve all stores based on a group of store unique ids"
    post "/by_store_ids" do
      logger.info "Retrieved stores wiht unique ids: #{params[:store_ids]}"
      GetStoresByIdsContext.call(params[:store_ids])
    end

    desc "Retrieve all features stores"
    get "/featured" do
      logger.info "Retrieved featured stores"
      GetFeaturedStoresContext.call(10)
    end

    desc "Retrieve all stores in a paginated form"
    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      logger.info "Retrieved all stores paginated"
      @page = params[:page].to_i||30
      
      stores_return = Array.new
      Store.page(@page).each do |store|
        if store.id != 15
          stores_return << store.format_for_web_serivce
        end
      end
      stores_return
    end

    desc "Search Stores with or without GPS"
    params do
      requires :query_term, :type => String, :desc => "Search query."
    end
    post "/search" do
      if params[:latitude].nil? && params[:longitude].nil? || params[:latitude] == 0 && params[:longitude]== 0
        logger.info "Searching all Stores for Term: #{params[:query_term]}"
        SearchStoresContext.call(params[:query_term], params[:page])
      else
        logger.info "Searching with Geo-Coordinates lat:#{params[:latitude]} long:#{params[:longitude]}"
        SearchStoresWithGPSContext.call(params[:query_term], params[:latitude], params[:longitude], params[:page])
      end
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

    desc "Retrieve a specific store"
    params do
      requires :id, :type => Integer, :desc => "Store id."
      requires :state, :type => String, :desc => "The order state to search for."
    end
    get "/:id/orders_for_today" do 
      logger.info "Showing orders with state in progress for Store with ID: #{params[:id]}"
      GetOrdersForStoreContext.call(params[:id], params[:state])
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
      GetNewStoreOrdersContext.call(store)
    end

    desc "Get new orders for vosto."
    post "/new_orders" do
      logger.info "Retrieved all new orders"
      authenticated_user
      GetNewOrdersContext.call
    end
  end
  
end