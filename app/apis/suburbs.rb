class Suburbs < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'suburbs' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/suburbs/store/1 -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/suburbs/store/15 -v

    desc "Get Suburbs."
    params do
      requires :id, :type => Integer, :desc => "Store id."
    end
    get "/store/:id" do
      logger.info "Getting Suburbs for Store with ID: #{params['id']}"
      GetSuburbsForCountryContext.call(params['id'])
    end

  end
end

