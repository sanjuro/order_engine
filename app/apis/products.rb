class Products < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'products' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/products.json?authentication_token=AXSSSSED2ASDASD1

    get "/" do
      authenticated_user
      logger.info "Retrieved all products"
      Products.all
    end
    
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get "/:id" do 
      logger.info "Showing Product with ID: #{params['id']}"
      Product.find(params['id'])
    end
    
  end
  
end