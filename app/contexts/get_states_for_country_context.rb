# Context to  retrieve all sububrbs
#
#
# Author::    Shadley Wentzel

class GetStatesForCountryContext
  attr_reader :country_id

  def self.call(country_id)
    GetStatesForCountryContext.new(country_id).call
  end

  def initialize(country_id)
    @country_id = country_id
  end

  def call
    states = State.where('country_id = ?',country_id).all

    states_return = Array.new
    states.each do |state|
      states_return << { "id" => state.id, "name" => state.name, "abbr" => state.abbr  }
    end
    states_return
  end
end