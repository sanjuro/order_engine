class Favourites < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'favourites' do

    # curl -i -H "Accept: application/json" http://localhost:9000/api/v1/favourties.json?authentication_token=AXSSSSED2ASDASD1

    get "/" do
      authenticated_user
      logger.info "Retrieved all favourties for #{current_user.full_name}"
      GetFavouritesContext.call(current_user) 
    end
    
    params do
      requires :id, :type => Integer, :desc => "Favourite id."
    end
    get "/:id" do 
      Favourite.find(params['id'])
    end
    
    post "/" do
      logger.info "Create new Favourite"
      favourtie = Favourtie.create(params['favourtie'])
    end
  end
  
end