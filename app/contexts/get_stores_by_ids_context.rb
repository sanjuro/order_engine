# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search/kauai
# Author::    Shadley Wentzel

class GetStoresByIdsContext
  attr_reader :store_ids

  def self.call(store_ids)
    GetStoresByIdsContext.new(store_ids).call
  end

  def initialize(store_ids)
    @store_ids = store_ids
  end

  def call
    # convert query terms
    store_ids = @store_ids

    store_results = Store.by_unique_ids(store_ids)

    stores_return = Array.new
    store_results.each do |store|
      stores_return << store.format_for_web_serivce
    end
    stores_return

  end
end
