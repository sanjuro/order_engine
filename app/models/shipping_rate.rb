class ShippingRate < Struct.new(:id, :shipping_method, :name, :cost, :currency)
  def initialize(attributes = {})
    attributes.each do |k, v|
      self.send("#{k}=", v)
    end
  end

  def display_price
    price = cost

    Money.new(price, { :currency => currency })
  end
end