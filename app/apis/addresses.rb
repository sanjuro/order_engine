class Addresses < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'addresses' do

    # curl -H 'Accept: application/json' -X POST -d '{"latitude": "-33.960350", "longitude": "18.470113"}'  http://127.0.0.1:9000/api/v1/addresses/get_address' -v

    desc "Get Address from Coordinates."
    params do
      requires :latitude, :type => String, :desc => "Store id."
      requires :longitude, :type => String, :desc => "Store id."
    end
    post "/get_address" do
      logger.info "Getting Address for Coordinates #{params.latitude} : #{params.longitude} "
      Geocoder.address([params.latitude,params.longitude])
    end

  end
end

