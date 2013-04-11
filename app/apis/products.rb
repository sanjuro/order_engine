class Products < Grape::API

# curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/products/1.json?authentication_token=CXTTTTED2ASDBSD3
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/products/152/grouped_option_values.json?authentication_token=CXTTTTED2ASDBSD3 -v
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/products/by_store?store_id=3&authentication_token=CXTTTTED2ASDBSD3
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/products/search?query=test&authentication_token=CXTTTTED2ASDBSD3
# curl -i -X POST -d '{"product_ids":["1","2"]}' 'http://107.22.211.58:9000/api/v1/products/by_ids' -v

  version 'v1', :using => :path
  format :json
  
  resource 'products' do

    desc "Retrieves all Products."
    get "/" do
      logger.info "Retrieved all products"
      Product.all
    end

    desc "Retrieve all products based on a group of prducts ids"
    post "/by_ids" do
      logger.info "Retrieved products wiht unique ids: #{params[:product_ids]}"
      GetProductsByIdsContext.call(params[:product_ids])
    end

    desc "Retrieves Products for a specific Store"
    params do
      requires :store_id, :type => Integer, :desc => "Store id."
    end
    get "/by_store" do
      logger.info "Retrieved all Products for Store ID: #{params[:store_id]}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 
      store = Product.by_store(params[:store_id])
    end

    desc "Search Products"
    params do
      requires :query, :type => String, :desc => "Search query."
    end
    get "/search" do
      logger.info "Searching all Products for Term: #{params[:query]}"
      # GetStoreByFanpageContext.call(params[:fanpage_id]) 

      search = Sunspot.search(Product) do
        fulltext params[:query]  do
          boost_fields :name => 10.0
        end   
        paginate :page => params[:page], :per_page => 15
      end

      search_results = search.results 
    end

    desc "Retrieves a specific Products"
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get "/:id" do 
      logger.info "Showing Product with ID: #{params[:id]}"
      Product.find(params[:id])
    end

    desc "Returns variants for a Product."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/variants' do
      logger.info "Retrieved all variants for Product with ID: #{params[:id]}"
      product = Product.find(params[:id])
      GetProductVariantsContext.call(product) 
    end

    desc "Returns option values for a Product."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/grouped_option_values' do
      logger.info "Retrieved all variants for Product with ID: #{params[:id]}"
      product = Product.find(params[:id])
      GetProductOptionValuesContext.call(product) 
    end

    desc "Returns variant of product using the option values."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/grouped_option_values' do
      logger.info "Retrieved all variants by option values for Product with ID: #{params[:id]}"
      product = Product.find(params[:id])
      GetVariantByOptionValuesContext.call(product) 
    end

    desc "Returns the master variant for a Product."
    params do
      requires :id, :type => Integer, :desc => "Product id."
    end
    get '/:id/master' do
      logger.info "Retrieved Master Variant for Product with ID: #{params['id']}"
      product = Product.find(params[:id])
      product.master
    end
    
  end
  
end