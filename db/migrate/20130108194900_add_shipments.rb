class AddShipments < ActiveRecord::Migration

	def self.up

		add_column :shipment_state,  :string
		add_column :stores, :can_deliver, :boolean, :default => false, :null => false
		add_column :users, :ship_address_id, :integer
		add_column :users, :bill_address_id, :integer

	    create_table :checkouts, :options => "ENGINE=INODB"  do |t|
	      t.references :order
	      t.string   :email, :ip_address
	      t.text     :special_instructions
	      t.integer  :bill_address_id
	      t.datetime :completed_at

	      t.timestamps
	    end
		
	    create_table :shipments, :options => "ENGINE=INODB"  do |t|
	      t.string :tracking
	      t.string :number
	      t.decimal :cost, :precision => 8, :scale => 2
	      t.datetime :shipped_at
	      t.references :order
	      t.references :address
	      t.string :state
	      t.timestamps
	    end

	    add_index :shipments, [:number], :name => 'index_shipments_on_number'


	    create_table :shipping_methods, :force => true do |t|
	      t.string   :name

	      t.timestamps
	    end


	end

	def self.down

    	remove_column :orders, :shipment_state
    	remove_column :stores, :can_deliver
    	remove_column :users, :ship_address_id
    	remove_column :users, :bill_address_id 	

    	drop_table :checkouts
    	drop_table :shipments

	end


end