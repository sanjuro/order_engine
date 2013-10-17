# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search/kauai
# Author::    Shadley Wentzel

class SearchStoresContext
  attr_reader :query_term, :page

  def self.call(query_term, page)
    SearchStoresContext.new(query_term, page).call
  end

  def initialize(query_term, page)
    @query_term = query_term
    @page = page
  end

  def call
    # convert query terms
    query_term = @query_term
    page = @page

  	search = Sunspot.search(Store) do
  		fulltext query_term do
  			boost_fields :unique_id => 10.0
  			boost_fields :store_name => 5.0
        # boost_fields :tag => 2.0
  		end   
      with :is_online, true
  		order_by :unique_id, :desc
  		paginate :page => page, :per_page => 15
  	end

  	search_results = search.results 

    stores_return = Array.new
    search_results.each do |store|
      stores_return << store.format_for_web_serivce
    end
    stores_return
  end
end
