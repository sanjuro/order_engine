class Calculator::FreeRate < Calculator
  # preference :amount, :decimal, :default => 0
  attr_accessible :amount

  def self.description
    I18n.t(:flat_rate_per_order)
  end

  def compute(object=nil)
    0
  end
end