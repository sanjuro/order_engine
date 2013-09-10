class AddLoyalty < ActiveRecord::Migration
  
	 def self.up
	    create_table :loyalties, :options => "ENGINE=INODB" do |t|
      		t.references :store_group
     		t.references :product_group
     		t.string   :name
     		t.string   :description
     		t.string   :prize
     		t.integer  :win_count
     		t.string :tag
     		t.boolean  :is_active,  :default => true

      		t.timestamps
	    end

	    create_table :loyalty_cards, :options => "ENGINE=INODB" do |t|
      		t.references :loyalty
     		t.references :user
     		t.integer  :count
     		t.boolean  :is_active,  :default => true
     		t.boolean  :is_won,  :default => false

      		t.timestamps
	    end

	    create_table :store_groups, :options => "ENGINE=INODB" do |t|
	      t.string :name
	    end

	    add_column :stores, :store_group_id, :integer

	    create_table :product_groups, :options => "ENGINE=INODB" do |t|
	      t.string :name
	    end

	    add_column :products, :product_group_id, :integer
	end

	def self.down
    	drop_table :loyalties
    	drop_table :loyalty_cards
    	drop_table :stores_groups
    	drop_table :products_groups

    	remove_column :stores, :stores_group_id
    	remove_column :products, :products_group_id
	end
end