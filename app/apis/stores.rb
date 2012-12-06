class Stores < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'stores' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores.json?authentication_token=AXSSSSED2ASDASD1

    get "/" do
      logger.info "Retrieved all stores"
      Store.all
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
    get '/:id/taxons' do
      logger.info "Retrieved all taxons for Store with ID#{params['id']}"
      store = Store.find(params[:id])
      store.taxons
    end
  end
  
end