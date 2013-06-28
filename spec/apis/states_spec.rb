require 'spec_helper'

describe States do
  include Rack::Test::Methods

  def app
    States
  end

    context "viewing all states for country with id" do

      	describe 'GET /api/v1/states/for_country/187' do

	        it 'should return a 200' do
	          get '/api/v1/states/for_country/187.json'
	          last_response.status.should == 200
	        end

	        it 'should return a list of suburbs' do
	          	get '/api/v1/states/for_country/187.json'
          	  	retrieved_states = JSON.parse(last_response.body)
          	   	retrieved_states.count.should >= 1	         
	        end

    	end

    end


end