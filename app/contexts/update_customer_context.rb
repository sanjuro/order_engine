# Context to update a customer
#
# Author::    Shadley Wentzel

class UpdateCustomerContext
  attr_reader :user, :user_data

  def self.call(user, user_data)
    UpdateCustomerContext.new(user, user_data).call
  end

  def initialize(user, user_data)
  	@user_data = user_data
    @user = user
    @user.extend CustomerRole
  end

  def call
    @user.update_customer(@user_data)
  end

end