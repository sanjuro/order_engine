# Class to model the line item resource
#
# Author::    Shadley Wentzel
class LineItem < ActiveRecord::Base
  before_validation :adjust_quantity
  belongs_to :order
  belongs_to :variant

  has_one :product, :through => :variant
  # has_many :adjustments, :as => :adjustable, :dependent => :destroy

  before_validation :copy_price

  validates :variant, :presence => true
  validates :quantity, :numericality => { :only_integer => true, :message => I18n.t('validation.must_be_int') }
  validates :price, :numericality => true

  attr_accessible :quantity, :variant_id

  after_save :update_order
  after_destroy :update_order

  def copy_price
    self.price = variant.price if variant && price.nil?
  end

  def increment_quantity
    self.quantity += 1
  end

  def decrement_quantity
    self.quantity -= 1
  end

  def amount
    price * quantity
  end
  alias total amount

  def adjust_quantity
    self.quantity = 0 if quantity.nil? || quantity < 0
  end

  private
    def update_inventory
      return true unless order.completed?
    end

    def remove_inventory
      return true unless order.completed?
    end

    def update_order
      # update the order totals, etc.
      order.update!
    end

end

