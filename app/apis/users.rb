class Users < Grape::API
  
  version 'v1', :using => :path
  format :json
  
  helpers do
    def logger
      API.logger
    end
  end

  resource 'users' do
    get "/" do
      authenticated_user
      logger.info "Retrieved all users"
      User.all
    end
    
    get "/:id" do 
      User.find(params['id'])
    end
    
    desc "Creates a new user of type customer"
    # params do
    #   requires :id, :type => Integer, :desc => "Product id."
    # end
    post '/create_customer' do
      logger.info "Creating new customer"
      SignupCustomerContext.call(params)
    end
  end
  
end