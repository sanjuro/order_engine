class AddTags < ActiveRecord::Migration

	def self.up
		add_column :stores, :tag, :string
	end

	def self.down
    	remove_column :stores, :tag
    end
end