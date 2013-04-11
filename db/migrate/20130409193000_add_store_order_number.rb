class AddStoreOrderNumber < ActiveRecord::Migration

	def self.up
		add_column :orders, :store_order_number, :string
	end

	def self.down
    	remove_column :orders, :store_order_number
    end
end