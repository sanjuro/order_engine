class Addresses < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'addresses' do

    # curl -H 'Accept: application/json' -X POST -d '{"latitude": "-33.960350", "longitude": "18.470113"}'  http://127.0.0.1:9000/api/v1/addresses/get_address -v
    # curl -H 'Accept: application/json' -X POST -d '{"store_id": "15","address":{"address1":"31 Ricketts Street","address2":"De Tyger","suburb_id": "33","city": "cape town", "state_id":"1061493587","country":"South Africa","latitude":"-33.960905","longitude":"18.470102"}}'  http://107.22.211.58:9000/api/v1/addresses/get_delivery_price -v

    desc "Get Address from Coordinates."
    params do
      requires :latitude, :type => String, :desc => "Latitude."
      requires :longitude, :type => String, :desc => "Longitude."
    end
    post "/get_address" do
      logger.info "Getting Address for Coordinates #{params.latitude} : #{params.longitude} "
      # result = Geocoder.geocode([params.latitude,params.longitude])
      GetAddressFromCoordsContext.call(params.latitude,params.longitude)
    end

    desc "Get Delivery cost for an address based on the store"
    post "/get_delivery_price" do
      logger.info "Getting Delivery cost for Address"
      GetDeliveryCostContext.call(params.store_id, params.address)
    end

  end
end

