class Clubs < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'clubs' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/clubs/ -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/clubs/ -v
    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/clubs/1?authentication_token=lb714q329neb1628m107a211an1176bz -v
    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/clubs/1?authentication_token=lb714q329neb1628m107a211an1176bz -v

    desc "Retrieve all clubs"
    get "/" do
      logger.info "Retrieved all clubs"      
      clubs_return = Array.new
      Club.all.each do |club|
        clubs_return << club.format_for_web_serivce
      end
      clubs_return
    end

    desc "Retrieve a specific club"
    params do
      requires :id, :type => Integer, :desc => "Club id."
    end
    get "/:id" do 
      logger.info "Redeem a Club with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"

      club = Club.find(params[:id])
      if !club.nil?
        GetClubByIdContext.call(club.id)
      else
        error!({ "error" => "Club error", "detail" =>  "Club could not be found" }, 400)  
      end
    end
  end
  
end