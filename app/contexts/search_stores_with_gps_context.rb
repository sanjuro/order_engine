# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search_gps?query=kauai&latitude=-33.864809&longitude=18.570908
# curl -i -X POST -d'{"query_term": "simply", "latitude": "-33.983967", "longitude": "18.480202"}' 'http://127.0.0.1:9000/api/v1/stores/search'
# Author::    Shadley Wentzel

class SearchStoresWithGPSContext
  attr_reader :query_term, :latitude, :longitude, :page

  def self.call(query_term, latitude, longitude, page)
    SearchStoresWithGPSContext.new(query_term, latitude, longitude, page).call
  end

  def initialize(query_term, latitude, longitude, page)
    @query_term, @latitude, @longitude, @page = query_term, latitude, longitude, page
  end

  def call
    # convert query terms
    query_term = @query_term
    page = @page
    latitude = @latitude.to_f
    longitude = @longitude.to_f

  	search = Sunspot.search(Store) do
  		fulltext query_term do
  			boost_fields :unique_id => 10.0
        boost_fields :store_name => 5.0
        boost_fields :tag => 2.0
  		end   

  		with(:location).near(latitude, longitude, :precision => 4, :bbox => true)
      # with(:location).in_radius(latitude, longitude, 50, :bbox => true)
  		# order_by :unique_id, :desc
      order_by :location, :desc
  		paginate :page => page, :per_page => 15
  	end

  	search_results = search.results 

  	stores_return = Array.new
  	search_results.each do |store|
      distance = store.distance_to([latitude, longitude], :km).round(2)
      if distance <= 25
		    stores_return << store.format_for_web_serivce_with_gps(latitude,longitude)
      end
  	end
  	stores_return
  end
end
