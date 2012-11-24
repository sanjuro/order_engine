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
      logger.info "Retrieved all users"
      User.all
    end
    
    get "/:id" do 
      User.find(params['id'])
    end
    
    post "/create" do
      # User.create(params['user'])
      logger.info "Creating a new user"
      @user = params['user']
      SignupCustomerContext.call(@user)
    end
  end
  
end