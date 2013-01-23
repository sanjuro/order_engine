class AddAdjustments < ActiveRecord::Migration

	def self.up
		create_table :spree_adjustments do |t|
			t.references :source, :polymorphic => true
			t.references :adjustable, :polymorphic => true
			t.references :originator, :polymorphic => true
			t.decimal :amount, :precision => 8, :scale => 2
			t.string :label
			t.boolean :mandatory
			t.boolean :locked
			t.boolean :eligible, :default => true
			t.timestamps
		end

	    create_table :preferences do |t|
			t.string :name, :limit => 100
			t.references :owner, :polymorphic => true
			t.text :value
			t.string :key
			t.string :value_type
			t.timestamps
	    end

	    add_index :preferences, [:key], :name => 'index_vosto_preferences_on_key', :unique => true
    end

	def self.down
    	drop_table :adjustments
    	drop_table :preferences
	end
end