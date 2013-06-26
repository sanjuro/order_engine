# Context to determine the delivery cost based on the address
#
# Author::    Shadley Wentzel

class GetAddressFromCoordsContext
  attr_reader :latitude, :longitude

  def self.call(latitude,longitude)
    GetAddressFromCoordsContext.new(latitude,longitude).call
  end

  def initialize(latitude,longitude)
    @latitude = latitude
    @longitude = longitude
  end

  def call
    # convert query terms
    latitude = @latitude
    longitude = @longitude

    results = Geocoder.search([latitude,longitude])
    geo = results.first

    address = Hash.new

    address = { 
            "address" => geo.address,
            "zipcode" => geo.postal_code,
            "city" => geo.city,
            "country" => geo.country,
          }

    p address
  end
end