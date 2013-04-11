require 'spec_helper'

describe Products do
  include Rack::Test::Methods

  def app
    Products
  end

    context "viewing products using a group of unique ids" do

      before :each do   
        @request_payload = {
          product_ids: 
            [
              "1",
              "2",
              "3"
            ]

        }
        post '/api/v1/products/by_ids', @request_payload.to_json
        
      end

      it 'SHOULD return a 200' do          
        last_response.status.should == 201
      end

      it 'SHOULD return products using the ids' do
        last_response.body.empty?.should == false
      end

    end

    context "viewing product option values" do

      before :each do   
        get '/api/v1/products/152/grouped_option_values.json'
      end

      it 'SHOULD return a 200' do          
        last_response.status.should == 200
      end

      it 'SHOULD return option values' do
        retrieved_options = JSON.parse(last_response.body)
        retrieved_options[0]['portion'].empty?.should == false
      end

    end
end