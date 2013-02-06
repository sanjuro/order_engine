# Context to retrieve all orders for a user
#
# Author::    Shadley Wentzel

class GetFavouritesContext
  attr_reader :user

  def self.call(user)
    GetFavouritesContext.new(user).call
  end

  def initialize(user)
    @user = user
    @user.extend CustomerRole
  end

  def call
    # return favourties
    @user.get_favourites
  end
end