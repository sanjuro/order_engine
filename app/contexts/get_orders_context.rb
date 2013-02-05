# Context to retrieve all orders for a user
#
# Author::    Shadley Wentzel

class GetOrdersContext
  attr_reader :user, :page

  def self.call(user, page)
    GetOrdersContext.new(user, page).call
  end

  def initialize(user, page)
    @page = page
    @user = user
    @user.extend CustomerRole
  end

  def call
    @user.get_orders(@page)
  end
end