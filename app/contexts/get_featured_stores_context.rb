# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search/kauai
# Author::    Shadley Wentzel

class GetFeaturedStoresContext
  attr_reader :store_count

  def self.call(store_count)
    GetFeaturedStoresContext.new(store_count).call
  end

  def initialize(store_count)
    @store_count = store_count
  end

  def call
    # convert query terms
    store_count = @store_count

    store_results = Store.featured_stores.limit(store_count)

    stores_return = Array.new
    store_results.each do |store|
      stores_return << store.format_for_web_serivce
    end
    stores_return

  end
end
