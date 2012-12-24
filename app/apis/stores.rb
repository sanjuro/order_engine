class Stores < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'stores' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores?authentication_token=AXSSSSED2ASDASD1

    params do
      requires :page, :type => Integer, :desc => "Page of results"
    end
    get "/page/:page" do
      logger.info "Retrieved all stores"
      @page = params[:page].to_i||30
      limit = 5
      offset = RPL::paginate @page, limit

      Store.all :limit => limit, :offset => offset, :order => 'created_at'
    end
    
    params do
      requires :fanpage_id, :type => Integer, :desc => "Fanpage id."
    end
    get "/by_fanpage" do
      logger.info "Retrieved all Store with Fanpage ID: #{params['fanpage_id']}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 
      store = Store.by_fanpage_id(params[:fanpage_id])
    end

    params do
      requires :unique_id, :type => String, :desc => "Unique ID"
    end
    get "/by_unique_id" do
      logger.info "Retrieved Store with Unique ID: #{params['unique_id']}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 
      store = Store.by_unique_id(params[:unique_id]).first
    end

    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id" do 
      logger.info "Showing Store with ID: #{params['id']}"
      Store.find(params['id'])
    end
    
    desc "Returns taxons for a store."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/:id/taxons" do
      logger.info "Retrieved all taxons for Store with ID#{params['id']}"
      store = Store.find(params[:id])
      store.taxons
    end
  end
  
end