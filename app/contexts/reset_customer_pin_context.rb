# Context to reset a customers pin
#
# 
# Author::    Shadley Wentzel

class ResetCustomerPinContext
  attr_reader :user

  def self.call(user)
    ResetCustomerPinContext.new(user).call
  end

  def initialize(user)
    @user = user
    @user = user.extend CustomerRole
  end

  def call
  	@user.reset_pin
  end
end