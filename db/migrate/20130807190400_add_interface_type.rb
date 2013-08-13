class AddInterfaceType < ActiveRecord::Migration
  
	 def self.up
	    create_table :interface_types, :force => true do |t|
			t.string :name
	    end

	    add_column :stores, :interface_type_id, :integer
	end

	def self.down
    	drop_table :interface_types
	end
end