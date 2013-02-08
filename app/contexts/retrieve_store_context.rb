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

    # return store with business hours attached
    store.format_for_web_serivce
  end
end