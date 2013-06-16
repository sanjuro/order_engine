class AddGeoToAddress < ActiveRecord::Migration

	def self.up
		add_column :addresses, :latitude, :string
		add_column :addresses, :longitude, :string
	end

	def self.down
    	remove_column :addresses, :latitude
    	remove_column :addresses, :longitude
    end
end