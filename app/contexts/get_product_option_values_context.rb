# Context to retrieve the option values related to a product
#
# Author::    Shadley Wentzel

class GetProductOptionValuesContext
  attr_reader :product

  def self.call(product)
    GetProductOptionValuesContext.new(product).call
  end

  def initialize(product)
    @product = product
  end

  def call
    # get all base variants
    option_types = @product.grouped_option_values
    # @product.option_values

    formatted_option_types = Array.new

    option_types.each do |option_type|
      # option_type_name = option_type[0][:name]
      option_types_return = Hash.new

      option_types_return[option_type[0][:presentation]] = option_type[1]
      formatted_option_types << option_types_return
    end

    formatted_option_types
  end

end