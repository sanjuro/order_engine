class Suburb < ActiveRecord::Base
  belongs_to :state

  validates :state, :name, :presence => true

  attr_accessible :name, :state_id

  def self.find_all_by_name(name)
    where('name = ?', name)
  end

  def to_s
    name
  end
end