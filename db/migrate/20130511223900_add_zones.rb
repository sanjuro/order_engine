class AddZones < ActiveRecord::Migration

  def self.up
    add_column :addresses, :suburb_id, :integer

    create_table :suburbs do |t|
      t.references :state
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

    create_table :zones_rates do |t|
      t.references :zone
      t.references :store
      t.decimal :rate, :precision => 8, :scale => 2, :default => 0.0, :null => false
    end
  end

  def self.down
    end
end