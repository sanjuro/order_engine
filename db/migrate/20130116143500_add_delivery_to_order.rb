class AddDeliveryToOrder < ActiveRecord::Migration

	def self.up
		add_column :orders, :is_delivery, :boolean, :default => false, :null => false
	end

	def self.down
    	remove_column :orders, :is_delivery
	end


end