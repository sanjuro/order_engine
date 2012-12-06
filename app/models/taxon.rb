# Class to model the taxon resource
#
# Author::    Shadley Wentzel
#
# == Schema Information
#
# Table name: taxons
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

require 'awesome_nested_set'

class Taxon < ActiveRecord::Base
    acts_as_nested_set :dependent => :destroy

    belongs_to :taxonomy
    has_and_belongs_to_many :products, :join_table => 'products_taxons'
    has_and_belongs_to_many :stores, :join_table => 'stores_taxons'

    attr_accessible :name, :parent_id, :position, :icon, :description, :taxonomy_id

    validates :name, :position, :presence => true

    # has_attached_file :icon,
    #   :styles => { :mini => '32x32>', :normal => '128x128>' },
    #   :default_style => :mini,
    #   :url => '/spree/taxons/:id/:style/:basename.:extension',
    #   :path => ':rails_root/public/spree/taxons/:id/:style/:basename.:extension',
    #   :default_url => '/assets/default_taxon.png'

    # indicate which filters should be used for a taxon
    # this method should be customized to your own site
    def applicable_filters
      fs = []
      # fs << ProductFilters.taxons_below(self)
      ## unless it's a root taxon? left open for demo purposes

      fs << ProductFilters.price_filter if ProductFilters.respond_to?(:price_filter)
      fs << ProductFilters.brand_filter if ProductFilters.respond_to?(:brand_filter)
      fs
    end

    def active_products
      scope = products.active
      scope
    end

end
