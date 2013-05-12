class AddZones < ActiveRecord::Migration

  def self.up
    create_table :suburbs do |t|
      t.string     :name
      t.string     :description
      t.timestamps
    end

    create_table :zone_members do |t|
      t.references :zoneable, :polymorphic => true
      t.references :zone
      t.timestamps
    end

    create_table :zones do |t|
      t.string     :name
      t.string     :description
      t.boolean    :default_tax,        :default => false
      t.integer    :zone_members_count, :default => 0
      t.timestamps
    end
  end

  def self.down
    end
end