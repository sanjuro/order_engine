# Context to retrieve a specific store
#
# Author::    Shadley Wentzel

class RetrieveStoreContext
  attr_reader :store_id

  def self.call(store_id)
    RetrieveStoreContext.new(store_id).call
  end

  def initialize(store_id)
    @store_id = store_id
  end

  def call
    # return favourties
    store = Store.find(@store_id)
    business_hours = store.business_hours

    store[:business_hours] = business_hours

    # return store with business hours attached
    store
  end
end