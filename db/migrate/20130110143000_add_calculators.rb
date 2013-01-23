class AddCalculators < ActiveRecord::Migration
  
	 def self.up
	    create_table :calculators, :force => true do |t|
	      t.string   :type
	      t.integer  :calculable_id,   :null => false
	      t.string   :calculable_type, :null => false

	      t.timestamps
	    end
	end

	def self.down
    	drop_table :calculators
	end
end