class Clubs < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'clubs' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/clubs/ -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/clubs/ -v

    desc "Retrieve all clubs"
    get "/" do
      logger.info "Retrieved all clubs"      
      clubs_return = Array.new
      Club.all.each do |club|
        clubs_return << club.format_for_web_serivce
      end
      clubs_return
    end
  end
  
end