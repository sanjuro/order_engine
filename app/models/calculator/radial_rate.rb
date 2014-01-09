class Calculator::RadialRate < Calculator
  # preference :amount, :decimal, :default => 0
  attr_accessible :amount
  

  def self.description
    I18n.t(:radial_rate_per_order)
  end

  def compute(object=nil)

    @RATE_PER_KILOMETER = 5
    if object.is_a?(Order)
      order = object
      store = order.store
      ship_address = order.ship_address
      postal_code = order.zipcode
    else
      store = object[:store]
      ship_address = object[:address]

      
    end

    postal_code = ship_address.zipcode
    suburb = ship_address.suburb
    
    search_phrase = "#{ship_address} #{suburb} #{postal_code}"
    search = Geocoder.search(search_phrase)
    puts 'doing the reverse geo now %s'%search.first.data['formatted_address']

    if search.count > 0

      distance = store.distance_from(search_phrase).to_f*1.60934
      exact_fair = distance * @RATE_PER_KILOMETER

      final_delivery_fair = 0
      if exact_fair <= 10
        final_delivery_fair = 10
      elsif exact_fair <= 40
        final_delivery_fair = exact_fair.ceil
      else
        final_delivery_fair = 50
      end
      final_delivery_fair
    else

      15 #return a default R15.00 as a delivery price if the location is not found

    end
  end
end