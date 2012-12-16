# Context to assocaite to add a new order
#
# curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"auth_token": "C3CDR1DCKZQ56NSMXL2BDZN8ZBS6LLL0", "order": {"address": {"alias":"Delivery","id_country": "US", "firstname":"test","lastname":"test","billing_name":"test","address1":"test","address2":"test","postcode":"1234","city":"test","phone":"8001231234"}}}' http://localhost:3000/api/v1/orders/144/add_address
# Author::    Shadley Wentzel

class NewCustomerOrderContext
  attr_reader :user, :order

  def self.call(user, order)
    NewCustomerOrderContext.new(user, order).call
  end

  def initialize(user, order, address)
    @user, @order, @address = user, order
    @user.extend CustomerRole
  end

  def call
    # find the correct customer object for the address
    @user.create_new_order(@order)
  end
end