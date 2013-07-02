class AddRegionToStore < ActiveRecord::Migration

	def self.up
		add_column :stores, :suburb_id, :integer
		add_column :stores, :state_id, :integer
		add_column :stores, :country_id, :integer
	end

	def self.down
    	remove_column :stores, :suburb_id
    	remove_column :stores, :state_id
    	remove_column :stores, :country_id
    end
end