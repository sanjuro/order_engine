# Context to assocaite to add a new order
#
# curl -i -X POST -d '{"authentication_token":"1b032cb31ad1f41e662238182ebbf456","order":{"unique_id":"kau0000001", "special_instructions":"I would like my Burrito on wholeweat", "device_identifier": "12345", "device_type": "blackberry", "line_items":[{"variant_id":"13","quantity":"1"},{"variant_id":"12","quantity":"1"}]}}' http://107.22.211.58:9000/api/v1/orders
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