class Devices < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'devices' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/orders/page/1?authentication_token=AXSSSSED2ASDASD6
    # curl -i -H "Accept: application/json" -X POST -d '{"device":{"device_type":"", "device_identifier":"", "device_token": "12345", "deviceable_id":"blackberry", "deviceable_type":"" }}' http://127.0.0.1:9000/api/v1/devices/register?authentication_token=1b032cb31ad1f41e662238182ebbf456

    desc "Register new Device"
    post "/register" do      
      logger.info "Register new Device"
      authenticated_user
      RegisterNewDeviceContext.call(params,current_user) 
    end
  end
  
end