class AddIsOnline < ActiveRecord::Migration

	def self.up
		add_column :stores, :is_online, :boolean, :default => false, :null => false
	end

	def self.down
    	remove_column :stores, :is_online
	end
end