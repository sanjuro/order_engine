require 'spec_helper'

describe Stores do
  include Rack::Test::Methods

  def app
    Stores
  end

    context "viewing all stores" do

      describe 'GET /api/v1/stores' do
        it 'should return a 200 when an access token is provided to /api/v1/stores' do
          get '/api/v1/stores.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end
      end

      describe 'GET /api/v1/stores/:id' do
        store = Store.all.first
        it 'should return a 200 and the requested store' do
          get "/api/v1/stores/#{store.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store = JSON.parse(last_response.body)
          retrieved_store["unique_id"].should == store.unique_id
        end
      end

      describe 'GET /api/v1/stores/page/:page' do
        it 'should return a 200 and the requested store' do
          get "/api/v1/stores/page/1?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store = JSON.parse(last_response.body)
        end
      end
    end
  
end