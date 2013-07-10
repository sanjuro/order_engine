# Context to  retrieve all sububrbs
#
#
# Author::    Shadley Wentzel

class GetSuburbsForCountryContext
  attr_reader :country_id

  def self.call(country_id)
    GetSuburbsForCountryContext.new(country_id).call
  end

  def initialize(country_id)
    @country_id = country_id
  end

  def call
    suburbs = Suburb.order('name ASC').all

    suburbs_return = Array.new
    suburbs.each do |suburb|
      suburbs_return << { "id" => suburb.id, "name" => suburb.name }
    end
    suburbs_return
  end
end