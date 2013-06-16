# Class to model the user stores resource
#
# Author::    Shadley Wentzel
class ZonesRates < ActiveRecord::Base
  belongs_to :zone
  belongs_to :store

  attr_accessible :zone_id, :store_id, :rate

  def self.get_rate(zone_id,store_id)
  	zone_rate = ZonesRates.where('zone_id = ?', zone_id).where('store_id = ?', store_id).first
	zone_rate.rate
  end
end