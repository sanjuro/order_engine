require 'spec_helper'

describe Devices do
  include Rack::Test::Methods

  def app
    Devices
  end

    context "POST /api/v1/devices/:id/status" do

      context "GIVEN registering a new device" do

        before :each do   
          @request_payload = {
            authentication_token: "CXTTTTED2ASDBSD4",
            device: {
              device_type: 1,
              device_identifier: "PP-oad11-1234",
              device_token: "1234",
              device_type: 'blackberry'
            }
          }
          post '/api/v1/devices/register',  @request_payload.to_json
        end

        it 'SHOULD return a 200' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the status of the order' do
          last_response.body.empty?.should == false
        end
      end
    end  
  
end