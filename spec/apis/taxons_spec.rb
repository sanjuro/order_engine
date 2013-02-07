require 'spec_helper'

describe Taxons do
  include Rack::Test::Methods

  def app
    Taxons
  end

    context "viewing all taxons" do

      describe 'GET /api/v1/taxons' do
        it 'should return a 200 when an access token is provided to /api/v1/taxons' do
          get '/api/v1/taxons.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end
      end

      describe 'GET /api/v1/taxons/:id' do
        taxon = Taxon.all.first
        it 'should return a 200 and the requested store' do
          get "/api/v1/taxons/#{taxon.id}.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store = JSON.parse(last_response.body)
          retrieved_store["id"].should == taxon.id
        end
      end

      describe 'GET /api/v1/taxons/:id/products' do

        before :each do    
          taxon = Taxon.find(4)    
          get "/api/v1/taxons/#{taxon.id}/products?authentication_token=CXTTTTED2ASDBSD3"
          @retrieved_products = JSON.parse(last_response.body)
        end

        it 'should return a 200' do
          last_response.status.should == 200
        end

        it 'and the products for that taxon' do
          @retrieved_products.count.should > 1
        end

        it 'and the products need to have the name' do 
          @retrieved_products.first['name'].empty?.should == false
        end        

        it 'and the products need to have the sku' do 
          @retrieved_products.first['sku'].empty?.should == false
        end

        it 'and the products need to have the price' do 
          @retrieved_products.first['price'].empty?.should == false
        end

        it 'and the products need to have the store id' do 
          @retrieved_products.first['store_id'].nil?.should == false
        end
      end
    end
  
end