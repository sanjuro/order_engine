class AddStoresTags < ActiveRecord::Migration

	def self.up
	    create_table :stores_tags do |t|
	      t.references :store
	      t.references :tag
	    end

	    create_table :tags, :force => true do |t|
	      t.string   :name, :null => false
	    end
	end

	def self.down
    	drop_table :stores_tags

    	drop_table :tags
    end
end