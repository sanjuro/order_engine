class Deals < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'deals' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/deals/ -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/deals/ -v

    desc "Retrieve all deals"
    get "/" do
      logger.info "Retrieved all deals"      
      deals_return = Array.new
      Deal.all.each do |deal|
        deals_return << deal.format_for_web_serivce
      end
      deals_return
    end
  end
  
end