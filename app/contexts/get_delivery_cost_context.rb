# Context to determine the delivery cost based on the address
#
# Author::    Shadley Wentzel

class GetDeliveryCostContext
  attr_reader :store_id, :address

  def self.call(store_id,address)
    GetDeliveryCostContext.new(store_id,address).call
  end

  def initialize(store_id,address)
    @store_id = store_id
    @address = address
  end

  def call
    # convert query terms
    store_id = @store_id
   
    shipping_method = Order.available_delivery_methods(store_id)

    shipping_data = Hash.new
    shipping_address = Address.create(
                :address1 => address.address1,
                :address2 => address.address2,
                :suburb_id => address.suburb_id,           
                :city => address.city,
                :zipcode => address.zipcode,
                :latitdue => address.latitude,
                :longitude => address.longitude
                )

    shipping_data[:store] = Store.find(store_id)
    shipping_data[:address] = shipping_address

    cost = shipping_method.calculator.compute(shipping_data).to_i
  end
end