require 'spec_helper'

describe Suburbs do
  include Rack::Test::Methods

  def app
    Suburbs
  end

    context "viewing all suburbs for store with id" do

      	describe 'GET /api/v1/suburbs/store/1' do

	        it 'should return a 200' do
	          get '/api/v1/suburbs/store/1.json'
	          last_response.status.should == 200
	        end

	        it 'should return a list of suburbs' do
	          	get '/api/v1/suburbs/store/1.json'
          	  	retrieved_suburbs = JSON.parse(last_response.body)
          	   	retrieved_suburbs.count.should >= 1	         
	        end

    	end

    end


end