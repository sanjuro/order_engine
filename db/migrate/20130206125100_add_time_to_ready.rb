class AddTimeToReady < ActiveRecord::Migration

	def self.up
		add_column :orders, :time_to_ready, :string
		add_column :orders, :time_to_ready, :string
	end

	def self.down
    	remove_column :orders, :time_to_ready
    end
end