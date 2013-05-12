class AddStoreToShippingMethod < ActiveRecord::Migration

	def self.up
		add_column :shipping_methods, :store_id, :integer
	end

	def self.down
    	remove_column :shipping_methods, :store_id
    end
end