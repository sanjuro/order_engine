class LoyaltyCards < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'loyalty_cards' do

    # curl -i -H "Accept: application/json" http://107.22.211.58:9000/api/v1/loyalty_cards/1?authentication_token=2d3c4c50602fbd3edce50fe62bace6e0 -v

    desc "Returns all loyalty cards for a customer"
    get "/by_customer" do  
      logger.info "Retrieved all loyalty cards for a customer"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"

      user = User.find(current_user.id)
      if !user.nil?
        GetLoyaltyCardsForCustomerCostContext.call(user) 
      else
        error!({ "error" => "Customer error", "detail" =>  "Customer could not be found" }, 400)  
      end
    end


    desc "Retrieve a specific loyalty card"
    params do
      requires :id, :type => Integer, :desc => "Loyalty Card id."
    end
    get "/:id" do 
      logger.info "Retrieveing Loyalty Card with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"
      
      loyalty_card = LoyaltyCard.find(params[:id])
      if !loyalty_card.nil?
        GetLoyaltyCardContext.call(loyalty_card.id)
      else
        error!({ "error" => "Loyalty Card error", "detail" =>  "Loyalty Card could not be found" }, 400)  
      end
    end

  end
end