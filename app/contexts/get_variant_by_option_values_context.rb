# Context to find a variant based on 2 option values
#
# curl -i -H "Accept: application/json" http://localhost:9000/api/v1/stores/search/kauai
# Author::    Shadley Wentzel

class GetVariantByOptionValuesContext
  attr_reader :product, :option_values

  def self.call(product, option_values)
    GetVariantByOptionValuesContext.new(product, option_values).call
  end

  def initialize(product, option_values)
    @product = product
    @option_values = option_values
  end

  def call
    # convert query terms
    option_values = @option_values
    product = @product

    # find all variants
    variants = product.variants_for_option_value(OptionValue.find(option_values[0]))

    option_value_check = nil
    matching_variant = nil

    if option_values.count > 1 
      option_value = OptionValue.find(option_values[1])
      variants.each do |variant|
        if option_value_check.nil?
          option_value_check = variant.option_values.detect { |o| o.id == option_value.id }

          # if the correct option value is found this must be the correct variant
          if !option_value_check.nil?
            matching_variant = variant
          end

        end
      end
    end
    
    matching_variant
  end
end
