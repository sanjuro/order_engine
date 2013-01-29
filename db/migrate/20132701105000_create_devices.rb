class CreateDevices < ActiveRecord::Migration
  
	 def self.up
	    create_table :devices, :force => true do |t|
      		t.references :store
			t.string   :device_type
			t.string   :device_identifier, :null => false
			t.string   :device_message_token, :null => false
			t.string   :deviceable_type
			t.string   :deviceable_id
			t.boolean  :is_active

			t.timestamps
	    end
	end

	def self.down
    	drop_table :devices
	end
end