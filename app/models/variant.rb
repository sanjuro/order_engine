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

    include Sunspot::ActiveRecord

    belongs_to :product, :touch => true

    attr_accessible :presentation, :position, :option_value_ids, :reward_points_gain, :reward_points_spend, 
                    :product_id, :option_values_attributes, :price, :option_values, :product_group_id

    attr_accessor  :sku, :name   
    attr_writer  :sku, :name  

    has_many :inventory_units
    has_many :line_items
    has_and_belongs_to_many :option_values, :join_table => 'option_values_variants'
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

    def to_hash
      actual_price = self.price
      #actual_price += Calculator::Vat.calculate_tax_on(self) if Spree::Config[:show_price_inc_vat]
      {
        :id => self.id,        
        :price => actual_price
      }
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

      values.to_sentence({ :words_connector => ", ", :two_words_connector => ", ", :last_word_connector => ", " })
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

    class << self
      # Returns variants that match a given option value
      #
      # Example:
      #
      # product.variants_including_master.has_option(OptionType.find_by_name("shoe-size"),OptionValue.find_by_name("8"))
      def has_option(option_type, *option_values)
        option_types = OptionType.table_name

        option_type_conditions = case option_type
        when OptionType then { "#{option_types}.name" => option_type.name }
        when String     then { "#{option_types}.name" => option_type }
        else                 { "#{option_types}.id"   => option_type }
        end

        relation = joins(:option_values => :option_type).where(option_type_conditions)

        option_values_conditions = option_values.each do |option_value|
          option_value_conditions = case option_value
          when OptionValue then { "#{OptionValue.table_name}.name" => option_value.name }
          when String      then { "#{OptionValue.table_name}.name" => option_value }
          else                  { "#{OptionValue.table_name}.id"   => option_value }
          end
          relation = relation.where(option_value_conditions)
        end

        relation
      end

      alias_method :has_options, :has_option
    end

    # Function to calcualte and a loyalty item based on the product
    #
    # * *Args*    :
    #   - 
    # * *Returns* :
    #   - 
    # * *Raises* :
    #   - 
    #
    def add_loyalty(user_id)

      if !self.product_group_id.nil?

        product_group = ProductGroup.find(product.product_group_id)

        loyalty = product_group.loyalties.first

        loyalty_card = LoyaltyCard.by_loyalty(loyalty.id).by_user(user_id).where('is_won != 1').first

        if loyalty_card.nil?    
          new_loyalty_card = LoyaltyCard.new
          new_loyalty_card.loyalty_id = loyalty.id
          new_loyalty_card.user_id = user_id
          new_loyalty_card.count = 1
          new_loyalty_card.save
        else
          loyalty_card.count += 1
          if loyalty_card.count == loyalty.win_count
            loyalty_card.is_won = true
          end
          loyalty_card.save
        end
      else
        p 'No Loyalty added.'
      end

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
