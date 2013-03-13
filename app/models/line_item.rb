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

  attr_accessible :quantity, :variant_id, :special_instructions

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

  # def process!
  #   begin
  #     logger.info 'PROCESS ORDER ITEM'
  #     # Check stock level
  #     if product.inventory_level.check_level(self)
  #       update_attribute(:product_id, variant.product_id)
        
  #       # get a package for the quantity
  #       (1..self.quantity).each do |k|
  #         ret = variant.product_source.new_product(variant, self)
  #       end
        
  #       # Update stock level    
  #       decrease_stock_level
  #       logger.info 'UPDATE STOCK LEVEL'
        
  #     else
  #       logger.info 'INVENTORY LEVEL LOW ' + variant.product_source.description
  #       self.destroy();
  #       InventoryMailer.low_inventory_email(variant.product_source).deliver
  #       raise "Stock Level Error"
  #     end
  #   rescue Exception => e
  #     puts "#{ e } (#{ e.class })!"
  #   end
  # end

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

