require 'spec_helper'

describe StoreTags do
  include Rack::Test::Methods

  def app
    StoreTags
  end

  describe "GET /api/v1/store_tags'", :type => :api do

    context "GIVEN viewing all store tags" do

      context "AND when not authorized" do  
        
        it 'should return a 401 when no acces token is supplied /api/v1/store_tags' do
          get '/api/v1/store_tags'
          last_response.status.should == 401
        end

      end

      context "AND when authorized" do 

        it 'SHOULD return a 200 when an access token is provided to /api/v1/store_tags' do
          get '/api/v1/store_tags.json?authentication_token=CXTTTTED2ASDBSD3'
          last_response.status.should == 200
        end

        it 'SHOULD return a list of store tags' do
          get "/api/v1/store_tags.json?authentication_token=CXTTTTED2ASDBSD3"
          last_response.status.should == 200
          retrieved_store_tags = JSON.parse(last_response.body)
          retrieved_store_tags.count.should >= 1
        end
      end

    end

  end  

end