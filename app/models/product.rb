# PRODUCTS
# Products represent an entity for sale in a store.
# Products can have variations, called variants
# Products properties include description, permalink, availability,
#   shipping category, etc. that do not change by variant.
#
# MASTER VARIANT
# Every product has one master variant, which stores master price and sku, size and weight, etc.
# The master variant does not have option values associated with it.
# Price, SKU, size, weight, etc. are all delegated to the master variant.
# Contains on_hand inventory levels only when there are no variants for the product.
#
# VARIANTS
# All variants can access the product properties directly (via reverse delegation).
# Inventory units are tied to Variant.
# The master variant can have inventory units, but not option values.
# All other variants have option values and may have inventory units.
# Sum of on_hand each variant's inventory level determine "on_hand" level for the product.
#
# require File.dirname(__FILE__) + '/../../lib/delegates_attributes_to.rb'

class Product < ActiveRecord::Base
    # acts_as_tenant(:store)

    include Sunspot::ActiveRecord

    belongs_to :store

    has_many :product_option_types, :dependent => :destroy
    has_many :option_types, :through => :product_option_types
    has_many :product_properties, :dependent => :destroy
    has_many :properties, :through => :product_properties

    has_and_belongs_to_many :taxons, :join_table => 'products_taxons'

    has_one :master,
      :class_name => "Variant",
      :conditions => { :is_master => true }

    delegate_attributes :sku, :price, :is_master, :to => :master

    after_create :set_master_variant_defaults
    after_create :add_properties_and_option_types_from_prototype
    after_create :build_variants_from_option_values_hash, :if => :option_values_hash
    after_save :save_master

    has_many :variants,
      :class_name => "Variant",
      :conditions => { :is_master => false, :deleted_at => nil },
      :order => 'position ASC'

    has_many :variants_including_master,
      :class_name => "Variant",
      :conditions => { :deleted_at => nil },
      :dependent => :destroy

    has_many :variants_with_only_master,
      :class_name => "Variant",
      :conditions => { :is_master => true, :deleted_at => nil },
      :dependent => :destroy

    accepts_nested_attributes_for :variants, :allow_destroy => true

    def variant_images
      Image.joins("LEFT JOIN #{Variant.quoted_table_name} ON #{Variant.quoted_table_name}.id = #{Asset.quoted_table_name}.viewable_id").
      where("(#{Asset.quoted_table_name}.viewable_type = ? AND #{Asset.quoted_table_name}.viewable_id = ?) OR
             (#{Asset.quoted_table_name}.viewable_type = ? AND #{Asset.quoted_table_name}.viewable_id = ?)", Variant.name, self.master.id, Product.name, self.id).
      order("#{Asset.quoted_table_name}.position").
      extend(Core::RelationSerialization)
    end

    alias_method :images, :variant_images

    validates :name, :price, :sku, :presence => true

    attr_accessor :option_values_hash

    attr_reader :taxon_tokens

    attr_accessible :name, :description, :price, :sku, :meta_description, :taxon_tokens,
                    :meta_keywords, :deleted_at, :option_values_hash,
                    :product_properties_attributes, :variants_attributes, :option_type_ids

    accepts_nested_attributes_for :product_properties, :allow_destroy => true, :reject_if => lambda { |pp| pp[:property_name].blank? }

    alias :options :product_option_types

    scope :by_store, lambda {|store| where("products.store_id = ?", store)} 

    Sunspot.setup(Product) do
      text :name
    end

    after_initialize :ensure_master

    def taxon_tokens=(ids)
      self.taxon_ids = ids.split(",")
    end

    def ensure_master
      return unless new_record?
      self.master ||= Variant.new
    end

    # returns true if the product has any variants (the master variant is not a member of the variants array)
    def has_variants?
      variants.exists?
    end

    # Adding properties and option types on creation based on a chosen prototype
    attr_reader :prototype_id
    def prototype_id=(value)
      @prototype_id = value.to_i
    end

    # Ensures option_types and product_option_types exist for keys in option_values_hash
    def ensure_option_types_exist_for_values_hash
      return if option_values_hash.nil?
      option_values_hash.keys.map(&:to_i).each do |id|
        self.option_type_ids << id unless option_type_ids.include?(id)
        product_option_types.create({:option_type_id => id}, :without_protection => true) unless product_option_types.map(&:option_type_id).include?(id)
      end
    end

    # for adding products which are closely related to existing ones
    # define "duplicate_extra" for site-specific actions, eg for additional fields
    def duplicate
      p = self.dup
      p.name = 'COPY OF ' + name
      p.deleted_at = nil
      p.created_at = p.updated_at = nil
      p.taxons = taxons

      p.product_properties = product_properties.map { |q| r = q.dup; r.created_at = r.updated_at = nil; r }

      image_dup = lambda { |i| j = i.dup; j.attachment = i.attachment.clone; j }

      variant = master.dup
      variant.sku = 'COPY OF ' + master.sku
      variant.deleted_at = nil
      variant.images = master.images.map { |i| image_dup.call i }
      p.master = variant

      # don't dup the actual variants, just the characterising types
      p.option_types = option_types if has_variants?

      # allow site to do some customization
      p.send(:duplicate_extra, self) if p.respond_to?(:duplicate_extra)
      p.save!
      p
    end

    # use deleted? rather than checking the attribute directly. this
    # allows extensions to override deleted? if they want to provide
    # their own definition.
    def deleted?
      !!deleted_at
    end

    # split variants list into hash which shows mapping of opt value onto matching variants
    # eg categorise_variants_from_option(color) => {"red" -> [...], "blue" -> [...]}
    def categorise_variants_from_option(opt_type)
      return {} unless option_types.include?(opt_type)
      variants.active.group_by { |v| v.option_values.detect { |o| o.option_type == opt_type} }
    end

    def self.like_any(fields, values)
      where_str = fields.map { |field| Array.new(values.size, "#{self.quoted_table_name}.#{field} #{LIKE} ?").join(' OR ') }.join(' OR ')
      self.where([where_str, values.map { |value| "%#{value}%" } * fields.size].flatten)
    end

    def empty_option_values?
      options.empty? || options.any? do |opt|
        opt.option_type.option_values.empty?
      end
    end

    def property(property_name)
      return nil unless prop = properties.find_by_name(property_name)
      product_properties.find_by_property_id(prop.id).try(:value)
    end

    def set_property(property_name, property_value)
      ActiveRecord::Base.transaction do
        property = Property.where(:name => property_name).first_or_initialize
        property.presentation = property_name
        property.save!

        product_property = ProductProperty.where(:product_id => id, :property_id => property.id).first_or_initialize
        product_property.value = property_value
        product_property.save!
      end
    end

    private

      # Builds variants from a hash of option types & values
      def build_variants_from_option_values_hash
        ensure_option_types_exist_for_values_hash
        values = option_values_hash.values
        values = values.inject(values.shift) { |memo, value| memo.product(value).map(&:flatten) }

        values.each do |ids|
          variant = variants.create({ :option_value_ids => ids, :price => master.price }, :without_protection => true)
        end
        save
      end

      def add_properties_and_option_types_from_prototype
        if prototype_id && prototype = Prototype.find_by_id(prototype_id)
          prototype.properties.each do |property|
            product_properties.create({:property => property}, :without_protection => true)
          end
          self.option_types = prototype.option_types
        end
      end

      # ensures the master variant is flagged as such
      def set_master_variant_defaults
        master.sku = self.sku
        master.price = self.price 
        master.is_master = true
      end

      # there's a weird quirk with the delegate stuff that does not automatically save the delegate object
      # when saving so we force a save using a hook.
      def save_master
        master.save if master && (master.changed? || master.new_record?)
      end
end