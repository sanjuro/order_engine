class AddDeals < ActiveRecord::Migration
  
	 def self.up
	    create_table :deals, :force => true do |t|
			t.string :deal_name
			t.string :deal_description
			t.boolean :is_active, :default => false, :null => false
	      	t.integer :dealable_id,   :null => false
	      	t.string :dealable_type, :null => false

	      	t.timestamps
	    end
	end

	def self.down
    	drop_table :deals
	end
end