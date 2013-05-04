class Devices < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'devices' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/orders/page/1?authentication_token=AXSSSSED2ASDASD6
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token": "fa36bfe1887b23db203ab3e836517c51","device":{"device_type":"android", "device_identifier":"103edb7d8c4e3669", "device_token": "APA91bFgMkYWLlF68P9OkC8YhE7dPHjDWYWrRJDAolkSa19CS1jZ_79GkkAwfq3QWIimpKI0Otkf_u89vVkZdFH0tlXkoKdusvR7RazE7pbTx-mt_UWfg-URY_ebS7hlCS2SYpIH9tj1uAzMLAH_zoA6bZ6bJ9TOpQ"}}' http://127.0.0.1:9000/api/v1/devices/register
    # curl -i -H "Accept: application/json" -X POST -d '{"authentication_token": "DXTTTTED2ASDBSD3","device":{"device_type":"blackberry", "device_identifier":"PP-oad11-123456", "device_token": "12345"}}' http://107.22.211.58:9000/api/v1/devices/register -v

    desc "Register new Device"
    post "/register" do      
      logger.info "Register new Device #{params['device']}"
      authenticated_user
      RegisterNewDeviceContext.call(params['device'],current_user) 
    end
  end
  
end