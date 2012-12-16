class Products < Grape::API

# curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/products/1.json?authentication_token=AXSSSSED2ASDASD1
# curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/products/1.json?authentication_token=AXSSSSED2ASDASD1
  
  version 'v1', :using => :path
  format :json
  
  resource 'products' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/products/1/master.json?authentication_token=AXSSSSED2ASDASD1

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

    desc "Returns variants for a Product."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/variants' do
      logger.info "Retrieved all variants for Product with ID: #{params['id']}"
      product = Product.find(params[:id])
      p product.variants
      product.variants
    end

    desc "Returns the master variant for a Product."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/master' do
      logger.info "Retrieved Mater Variant for Product with ID: #{params['id']}"
      product = Product.find(params[:id])
      p product.master
      product.master
    end
    
  end
  
end