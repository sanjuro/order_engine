class AddDeviceNumber < ActiveRecord::Migration

	def self.up
	    create_table :device_types, :options => "ENGINE=INODB" do |t|
	      t.string     :title
	    end

		add_column :orders, :device_identifier, :string
		add_column :orders, :device_type, :string

	end

	def self.down
    	drop_table :device_types
		
    	remove_column :orders, :device_identifier
    	remove_column :orders, :device_type
    end
end