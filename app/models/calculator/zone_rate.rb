class Calculator::ZoneRate < Calculator
  # preference :amount, :decimal, :default => 0
  attr_accessible :amount

  def self.description
    I18n.t(:flat_rate_per_order)
  end

  def compute(object=nil)
  	if object.is_a?(Order)
  		order = object
    	store = order.store
    	ship_address = order.ship_address
  	else
  		store = object[:store]
  		ship_address = object[:address]
  	end

    shipping_zone = ship_address.get_zone('suburb',store.id)
    ZonesRates.get_rate(shipping_zone.id,store.id)	
  end
end