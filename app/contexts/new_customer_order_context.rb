# Context to assocaite to add a new order
#
# curl -i -X POST -d '{"authentication_token":"CXTTTTED2ASDBSD3","order":{"store_id":"1", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "12345",  "line_items":{ "variant_id":"13","quantity":1}}}' http://localhost:9000/api/v1/orders
# Author::    Shadley Wentzel
class NewCustomerOrderContext
  attr_reader :user, :order

  def self.call(user, order)
    NewCustomerOrderContext.new(user, order).call
  end

  def initialize(user, order)
    @user, @order = user, order
    @user.extend CustomerRole
  end

  def call
    # find the correct customer object for the address
    @user.create_new_order(@order)
  end
end