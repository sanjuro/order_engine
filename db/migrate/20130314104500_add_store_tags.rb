class AddStoreTags < ActiveRecord::Migration

	def self.up
	    create_table :store_tags do |t|
	      t.string    	:title    
	    end
	end

	def self.down
    	drop_table :store_tags
    end
end