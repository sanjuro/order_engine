class ShippingMethod < ActiveRecord::Base
  include CalculatedAdjustments

  DISPLAY = [:both, :front_end, :back_end]
  has_many :shipments
  validates :name, :zone, :presence => true

  belongs_to :shipping_category
  belongs_to :zone
  belongs_to :store

  attr_accessible :name, :zone_id, :display_on, :shipping_category_id,
                  :match_none, :match_one, :match_all

  calculated_adjustments

  def adjustment_label
    self.name
  end

  def available?(order, display_on = nil)
    displayable? && calculator.available?(order) && store_id == order.store_id
  end

  def displayable?
    # (self.display_on == display_on.to_s || self.display_on.blank?)
    true
  end

  def calculator_available?(order)
    caluclator.available?(order)
  end

  def within_zone?(order)
    zone && zone.include?(order.ship_address)
  end

  def available_to_order?(order, display_on= nil)
    # available?(order, display_on) &&
    # within_zone?(order) &&
    # category_match?(order)
    available?(order, display_on)
  end

  # Indicates whether or not the category rules for this shipping method
  # are satisfied (if applicable)
  def category_match?(order)
    return true if shipping_category.nil?

    if match_all
      order.products.all? { |p| p.shipping_category == shipping_category }
    elsif match_one
      order.products.any? { |p| p.shipping_category == shipping_category }
    elsif match_none
      order.products.all? { |p| p.shipping_category != shipping_category }
    end
  end

  def self.all_available(order, display_on = nil)
    all.select { |method| method.available_to_order?(order,display_on) }
  end
end