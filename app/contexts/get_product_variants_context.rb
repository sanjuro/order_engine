# Context to retrieve a prodcut with its variants and option values
#
# Author::    Shadley Wentzel
class GetProductVariantsContext
  attr_reader :product

  def self.call(product)
    GetProductVariantsContext.new(product).call
  end

  def initialize(product)
    @product = product
  end

  def call
    menu = Array.new

    @product.variants.each do |variant|
      variant_array = Array(variant)
      variant_array << { :option_values => variant.options_text }
      menu << variant_array
    end

    return menu
  end

end