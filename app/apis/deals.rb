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

    desc "Redeem a specific deal"
    params do
      requires :id, :type => Integer, :desc => "Deal id."
    end
    get "/:id/redeem" do 
      logger.info "Redeem a Deal with ID: #{params[:id]}"
      authenticated_user
      logger.info "Authenticated User: #{current_user.full_name}"

      deal = Deal.find(params[:id])
      if !deal.nil?
        RedeemDealContext.call(current_user,deal.id)
      else
        error!({ "error" => "Deal error", "detail" =>  "Deal could not be found" }, 400)  
      end
    end
  end
  
end