class AddActivatedToStore < ActiveRecord::Migration

	def self.up
		add_column :stores, :is_active, :boolean, :default => false, :null => false
	end

	def self.down
    	remove_column :stores, :is_active
    end
end