class States < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'states' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/states/for_country/187 -v

    desc "Get States for Country."
    params do
      requires :country_id, :type => Integer, :desc => "Country id."
    end
    get "/for_country/:country_id" do
      logger.info "Getting States for Country with ID: #{params['country_id']}"
      GetStatesForCountryContext.call(params['country_id'])
    end

  end
end

