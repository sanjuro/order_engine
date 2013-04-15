class Variants < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'variants' do

    # curl -i -H "Accept: application/json"  http://127.0.0.1:9000/api/v1/variants/245/find_option_values
    
    desc "Retrieve a specific Variant"
    get "/:id/find_option_values" do 
      variant = Variant.find(params['id'])
      variant.option_values
    end
    
  end
  
end