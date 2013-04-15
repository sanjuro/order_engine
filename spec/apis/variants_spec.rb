require 'spec_helper'

describe Variants do
  include Rack::Test::Methods

  def app
    Variants
  end

  context "Retrieve a option values for a specific variant" do

    describe 'GET /api/v1/variants/:id/find_option_values' do

      before :each do   
        get '/api/v1/variants/245/find_option_values'
      end

      it 'should return a 201' do  
        last_response.status.should == 200
      end

      it 'should return the correct option values' do  
        retrieved_option_values = JSON.parse(last_response.body)
        retrieved_option_values.count.should > 1
      end
    end
  end
end