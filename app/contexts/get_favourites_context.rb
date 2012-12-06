# Context to retrieve all orders for a user
#
# curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"auth_token": "C3CDR1DCKZQ56NSMXL2BDZN8ZBS6LLL0", "order": {"address": {"alias":"Delivery","id_country": "US", "firstname":"test","lastname":"test","billing_name":"test","address1":"test","address2":"test","postcode":"1234","city":"test","phone":"8001231234"}}}' http://localhost:3000/api/v1/orders/144/add_address
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