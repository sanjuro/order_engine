# Class to model the variant resource
#
# Author::    Shadley Wentzel
#
# == Schema Information
#
# Table name: variants
#
#  id                         :integer(4)      not null, primary key
#  full_name                  :string(255)
#  user_pin                   :string(255)
#  email                      :string(255)
#  mobile_number              :string(255)
#  gender                     :string(255)
#  encrypted_password         :string(255)
#  created_at                 :datetime
#  updated_at                 :datetime
#  user_id                    :integer(4)
#

class Variant < ActiveRecord::Base
    belongs_to :product, :touch => true

    attr_accessible :name, :presentation, :position, :option_value_ids,
                    :product_id, :option_values_attributes, :price, :sku

    has_many :inventory_units
    has_many :line_items
    has_and_belongs_to_many :option_values, :join_table => :spree_option_values_variants
    has_many :images, :as => :viewable, :order => :position, :dependent => :destroy

    delegate_attributes :name, :description, :meta_description, :meta_keywords, :to => :product

    validate :check_price
    validates :price, :numericality => { :greater_than_or_equal_to => 0 }, :presence => true

    # after_save :recalculate_product_on_hand, :if => :is_master?

    # default variant scope only lists non-deleted variants
    scope :active, where(:deleted_at => nil)
    scope :deleted, where('deleted_at IS NOT NULL')

    # Returns number of inventory units for this variant (new records haven't been saved to database, yet)
    # def on_hand
    #   1.0 / 0 # Infinity
    # end


    # strips all non-price-like characters from the price.
    def price=(price)
      if price.present?
        self[:price] = price.to_s.gsub(/[^0-9\.-]/, '').to_f
      end
    end

    # and cost_price
    # def cost_price=(price)
    #   if price.present?
    #     self[:cost_price] = price.to_s.gsub(/[^0-9\.-]/, '').to_f
    #   end
    # end

    # returns number of units currently on backorder for this variant.
    # def on_backorder
    #   inventory_units.with_state('backordered').size
    # end

    # returns true if at least one inventory unit of this variant is "on_hand"
    def in_stock?
       true
    end
    alias in_stock in_stock?

    # returns true if this variant is allowed to be placed on a new order
    def available?
       true
    end

    def options_text
      values = self.option_values.sort_by(&:position)

      values.map! do |ov|
        "#{ov.option_type.presentation}: #{ov.presentation}"
      end

      values.to_sentence({ :words_connector => ", ", :two_words_connector => ", " })
    end

    # def gross_profit
    #   cost_price.nil? ? 0 : (price - cost_price)
    # end

    # use deleted? rather than checking the attribute directly. this
    # allows extensions to override deleted? if they want to provide
    # their own definition.
    def deleted?
      deleted_at
    end

    def set_option_value(opt_name, opt_value)
      # no option values on master
      return if self.is_master

      option_type = OptionType.where(:name => opt_name).first_or_initialize do |o|
        o.presentation = opt_name
        o.save!
      end

      current_value = self.option_values.detect { |o| o.option_type.name == opt_name }

      unless current_value.nil?
        return if current_value.name == opt_value
        self.option_values.delete(current_value)
      else
        # then we have to check to make sure that the product has the option type
        unless self.product.option_types.include? option_type
          self.product.option_types << option_type
          self.product.save
        end
      end

      option_value = OptionValue.where(:option_type_id => option_type.id, :name => opt_value).first_or_initialize do |o|
        o.presentation = opt_value
        o.save!
      end

      self.option_values << option_value
      self.save
    end

    def option_value(opt_name)
      self.option_values.detect { |o| o.option_type.name == opt_name }.try(:presentation)
    end


    private

      # Ensures a new variant takes the product master price when price is not supplied
      def check_price
        if price.nil?
          raise 'Must supply price for variant or master.price for product.' if self == product.master
          self.price = product.price
        end
      end

end

# require_dependency 'spree/variant/scopes'
