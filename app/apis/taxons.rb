class Taxons < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'taxons' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/taxons/1/products.json?authentication_token=AXSSSSED2ASDASD1

    desc "Retrieve all Taxons."
    get "/" do
      logger.info "Retrieved all taxons"
      Taxon.all
    end
    
    desc "Retrieve a specific Taxons."
    params do
      requires :id, :type => Integer, :desc => "Taxon id."
    end
    get "/:id" do 
      logger.info "Showing Taxon with ID: #{params['id']}"
      Taxon.find(params['id'])
    end
    
    desc "Returns products for a taxon."
    params do
      requires :id, :type => Integer, :desc => "Taxon id."
    end
    get '/:id/products' do
      logger.info "Retrieved all products for Taxon with ID: #{params['id']}"
      taxon = Taxon.find(params[:id])
      taxon.products.where("deleted_at IS NULL")
    end
  end
  
end