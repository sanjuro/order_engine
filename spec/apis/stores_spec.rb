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

      describe 'GET /api/v1/stores/page/:page' do
        it 'should return a 200 and the requested store' do
          get "/api/v1/stores/page/1?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store = JSON.parse(last_response.body)
        end
      end

    end

    context "viewing a single store" do

      describe 'GET /api/v1/stores/:id' do
        store = Store.all.first
        it 'should return a 200 and the requested store' do
          get "/api/v1/stores/#{store.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store = JSON.parse(last_response.body)
          retrieved_store["unique_id"].should == store.unique_id
        end
      end

      describe 'GET /api/v1/stores/:id/taxons' do
        store = Store.all.first
        it 'should return a 200 and the taxons for that store' do
          get "/api/v1/stores/#{store.id}/taxons.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_taxons = JSON.parse(last_response.body)
          retrieved_taxons.count.should >= 1
        end
      end

      describe 'GET /api/v1/stores/:id/online' do
        store = Store.all.first
        it 'should return a 200 and set the store to online' do
          get "/api/v1/stores/#{store.id}/online?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_taxons = JSON.parse(last_response.body)
          store = Store.find(store.id)
          store.is_online.should == true
        end
      end

      describe 'GET /api/v1/stores/:id/offline' do
        store = Store.all.first
        it 'should return a 200 and set the store to offline' do
          get "/api/v1/stores/#{store.id}/offline?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_taxons = JSON.parse(last_response.body)
          store = Store.find(store.id)
          store.is_online.should == false
        end
      end

      describe 'GET /api/v1/stores/:id/new_orders' do
        store = Store.all.first
        it 'should return a 200 and retrieve all new orders for the store' do
          get "/api/v1/stores/#{store.id}/new_orders.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_orders = JSON.parse(last_response.body)
          retrieved_orders.count.should >= 1
        end
      end
    end  

    context "searching all stores" do
      describe 'GET /api/v1/stores/search' do

        before :each do        
          @request_payload = {
              authentication_token: "CXTTTTED2ASDBSD4",
              query_term: "kauai",
          }

          post '/api/v1/stores/search', @request_payload
          @retrieved_stores = JSON.parse(last_response.body)
        end

        it 'should return a 201' do  
          last_response.status.should == 201
        end

        it 'should return results that match the query term' do            
          @retrieved_stores.count.should >= 1
        end

        it 'should return a result with matching the term' do  
          @retrieved_stores.first['unique_id'].should == 'kau0000002'
        end

      end

    end
end