# Context to retrieve all products for a given taxon
#
# Author::    Shadley Wentzel

class GetProductsForTaxonContext
  attr_reader :taxon

  def self.call(taxon)
    GetProductsForTaxonContext.new(taxon).call
  end

  def initialize(taxon)
    @taxon = taxon
  end

  def call
  	products = Array.new

    # retrieve all products for taxon
    taxon.products.where("deleted_at IS NULL").each do |product|
    	products << product.formant_for_web_serivce
    end

    # return formatted products array
    products
  end
end
