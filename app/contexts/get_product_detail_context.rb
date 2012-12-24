# Context to retrieve a prodcut with its variants and option values
#
# Author::    Shadley Wentzel
class GetProductDetailContext
  attr_reader :product

  def self.call(product)
    GetProductDetailContext.new(product).call
  end

  def initialize(product)
    @product = product
  end

  def call
    menu = Array.new

    @product.variants.each do |variant|
      variant_array = Array(variant)
      variant_array << { :option_values => variant.option_values }
      menu << variant_array
    end

    return menu
  end

end