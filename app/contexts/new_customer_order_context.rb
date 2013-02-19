# Context to assocaite to add a new order
#
# curl -i -X POST -d '{"authentication_token":"54ec660cd621f87dcc9a76c0a33285d1","order":{"unique_id":"kau0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "DEfe123123", "device_type": "blackberry", "line_items":[{"variant_id":"11","quantity":"1"}]}}' http://107.22.211.58:9000/api/v1/orders
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