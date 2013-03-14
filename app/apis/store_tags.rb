class StoreTags < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'store_tags' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/store_tags?authentication_token=CXTTTTED2ASDBSD3

    desc "Returns all store tags"
    get "/" do  
      logger.info "Retrieved all store tags"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"

      StoreTag.all 
    end

  end
end