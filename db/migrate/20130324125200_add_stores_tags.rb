class AddStoresTags < ActiveRecord::Migration

	def self.up
		drop_table :store_tags

	    create_table :stores_tags do |t|
	      t.references :store
	      t.references :tag
	    end
	end

	def self.down
    	drop_table :stores_tags
    end
end