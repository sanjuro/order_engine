class AddDelivery < ActiveRecord::Migration

	def self.up

		add_column :stores, :can_deliver, :boolean, :default => false, :null => false

	    create_table :addresses, :options => "ENGINE=INODB" do |t|
	      t.string   :firstname, :lastname, :address1, :address2, :city,
	                 :zipcode, :phone, :state_name, :alternative_phone
	      t.references :state
	      t.references :country

	      t.timestamps
	    end

	    create_table :deliveries, :force => true do |t|
	      t.string   :tracking, :number
	      t.decimal  :cost, :precision => 8, :scale => 2
	      t.datetime :shipped_at
	      t.references :order
	      t.references :delivery_provider
	      t.references :address

	      t.timestamps
	    end

	    create_table :delivery_providers, :options => "ENGINE=INODB" do |t|
	      t.string   :provider_name
	    end

	    create_table :states, :options => "ENGINE=INODB" do |t|
	      t.string   :name
	      t.string   :abbr
	      t.references :country
	    end

	    create_table :countries, :options => "ENGINE=INODB" do |t|
	      t.string   :iso_name, :iso, :iso3, :name
	      t.integer  :numcode
	    end

	end

	def self.down

    	remove_column :stores, :can_deliver

    	drop_table :addresses
    	drop_table :states
    	drop_table :countries

	end


end