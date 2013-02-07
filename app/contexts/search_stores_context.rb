# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search?query=sim0000001&authentication_token=CXTTTTED2ASDBSD3
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
  			boost_fields :store_name => 2.0
  		end   
  		order_by :unique_id, :desc
  		paginate :page => page, :per_page => 15
  	end

  	search_results = search.results 
  end
end
