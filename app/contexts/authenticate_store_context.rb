# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search?query=sim0000001&authentication_token=CXTTTTED2ASDBSD3
# Author::    Shadley Wentzel
class AuthenticateStoreContext
  attr_reader :user, :password

  def self.call(user, password)
    AuthenticateStoreContext.new(user, password).call
  end

  def initialize(user, password)
    @user = user.extend StoreUserRole
    @password = password
  end

  def call
    # convert query termm
    store_user = @user.authenticate(@password)
  end
end