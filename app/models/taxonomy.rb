class Taxonomy < ActiveRecord::Base
  validates :name, :presence => true

  attr_accessible :name

  belongs_to :store

  has_many :taxons
  has_one :root, :conditions => { :parent_id => nil }, :class_name => "Taxon",
                 :dependent => :destroy

  after_save :set_name

  scope :by_store, lambda {|store| where("taxonomies.store_id = ?", store)} 

  private
    def set_name
      if root
        root.update_column(:name, name)
      else
        self.root = Taxon.create!({ :taxonomy_id => id, :name => name }, :without_protection => true)
      end
    end

end