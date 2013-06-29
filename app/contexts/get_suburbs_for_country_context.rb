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
    suburbs = Suburb.all

    suburbs_return = Array.new
    suburbs.each do |suburb|
      suburbs_return << { "id" => suburb.id, "name" => suburb.name, "state_id" => suburb.state.id, "state_name" => suburb.state.name }
    end
    suburbs_return
  end
end