class AddFeaturedToStore < ActiveRecord::Migration

	def self.up
		add_column :stores, :is_featured, :boolean, :default => false, :null => false
	end

	def self.down
    	remove_column :stores, :is_featured
    end
end