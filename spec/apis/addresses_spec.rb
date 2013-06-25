require 'spec_helper'

describe Addresses do
  include Rack::Test::Methods

  def app
    Addresses
  end

  context "POST /api/v1/addresses/get_address" do

      context "GIVEN finding address" do

        before :each do   
          @request_payload = {
            latitude: "-33.960350",
            longitude: "18.470113"
          }
          post '/api/v1/addresses/get_address',  @request_payload.to_json
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the address' do
          last_response.body.empty?.should == false
        end
    end


      context "GIVEN requesting new delivery price" do

        before :each do   
          @request_payload = {
            store_id: 1,
            address: {
              address1: "31 Ricketts Street",
              address2: "De Tyger",
              suburb_id: "1",
              city: "Cape Town",
              zipcode: "7500",
              country: "South Africa",
              latitude: "-33.960350",
              longitude: "18.470113"
            }
          }
          post '/api/v1/addresses/get_delivery_price',  @request_payload.to_json
        end

        it 'SHOULD return a 201' do          
          last_response.status.should == 201
        end

        it 'SHOULD return the price for delivery' do
          last_response.body.should == '15'
        end
      end

  end

end