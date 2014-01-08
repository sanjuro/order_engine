# Context to  retrieve all sububrbs
#
#
# Author::    Shadley Wentzel

class GetSuburbsForStoreContext
  attr_reader :store_id

  def self.call(store_id)
    GetSuburbsForStoreContext.new(store_id).call
  end

  def initialize(store_id)
    @store_id = store_id
  end

  def call
    
    zones_rates = ZonesRates.where('store_id = ?',store_id)

    suburbs_return = Array.new

    zoneable = Array.new
    zones_rates.each do |zones_rate|
      zoneable << zones_rate.zone
    end

    zoneable.each do |zone|
      zone.zoneables.each do |zoneable|
        suburbs_return << { "id" => zoneable.id, "name" => zoneable.name }
      end
    end
    
    suburbs_return
  end
end