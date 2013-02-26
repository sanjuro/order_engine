class Devices < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'devices' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/orders/page/1?authentication_token=AXSSSSED2ASDASD6
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token": "1b032cb31ad1f41e662238182ebbf456","device":{"device_type":"blackberry", "device_identifier":"PP-oad11-12345", "device_token": "12345"}}' http://107.22.211.58:9000/api/v1/devices/register

    desc "Register new Device"
    post "/register" do      
      logger.info "Register new Device #{params['device']}"
      authenticated_user
      RegisterNewDeviceContext.call(params['device'],current_user) 
    end
  end
  
end