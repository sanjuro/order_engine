class AddStoreToShippingMethod < ActiveRecord::Migration

	def self.up
		add_column :shipping_methods, :store_id, :integer
		add_column :shipping_methods, :shipping_method_id, :integer
	end

	def self.down
    	remove_column :shipping_methods, :store_id
    	remove_column :shipping_methods, :shipping_method_id
    end
end