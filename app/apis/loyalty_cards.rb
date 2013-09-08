class LoyaltyCards < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  resource 'loyalty_cards' do

    # curl -i -H "Accept: application/json" http://127.0.0.1:9000/api/v1/loyalty_cards/by_customer/127?authentication_token=DXTTTTED2ASDBSD3 -v

    desc "Returns all loyalty cards for a customer"
    get "/by_customer/:customer_id" do  
      logger.info "Retrieved all loyalty cards for a customer with ID: #{params.customer_id}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"

      user = User.find(params['customer_id'])
      if !user.nil?
        GetLoyaltyCardsForCustomerCostContext.call(user) 
      else
        error!({ "error" => "Customer error", "detail" =>  "Customer could not be found" }, 400)  
      end
    end

  end
end