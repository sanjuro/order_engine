# Context to assocaite to add a new order
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search/kauai
# Author::    Shadley Wentzel

class GetProductsByIdsContext
  attr_reader :product_ids

  def self.call(product_ids)
    GetProductsByIdsContext.new(product_ids).call
  end

  def initialize(product_ids)
    @product_ids = product_ids
  end

  def call
    # convert query terms
    product_ids = @product_ids

    product_results = Product.by_ids(product_ids)

    products_return = Array.new
    product_results.each do |product|
      products_return << product.format_for_web_serivce
    end
    products_return

  end
end
