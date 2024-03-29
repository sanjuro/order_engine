class CreateVosto < ActiveRecord::Migration
  
  def self.up
    create_table :access_grants, :options => "ENGINE=INODB", :id => false do |t|
      t.references :user
      t.references :client_application
      t.string     :code
      t.string     :authentication_token
      t.string     :refresh_token
      t.datetime   :authentication_token_expires_at
    end
    
    create_table :business_hours, :options => "ENGINE=INODB" do |t|
      t.references :store
      t.integer  :day
      t.time :open_time
      t.time :close_time
    end

    create_table :client_applications, :options => "ENGINE=INODB"do |t|
      t.string     :name

      t.timestamps
    end

    create_table :favourites, :options => "ENGINE=INODB" do |t|
      t.string      :favourite_type
      t.integer     :favourite_id
      t.references  :user

      t.timestamps
    end

    create_table :line_items, :options => "ENGINE=INODB" do |t|
      t.references :order
      t.references :variant
      t.integer  :quantity,                            :null => false
      t.decimal  :price, :precision => 8, :scale => 2, :null => false
      
      t.timestamps
    end

    add_index :line_items, :order_id, :name => 'index_line_items_on_order_id'
    add_index :line_items, :variant_id, :name => 'index_line_items_on_variant_id'

    create_table :option_types, :options => "ENGINE=INODB" do |t|
      t.string :name, :limit => 100
      t.string :presentation, :limit => 100
      t.integer :position

    end    
    
    create_table :option_values, :options => "ENGINE=INODB" do |t|
      t.integer :option_type_id
      t.string :name
      t.integer :position
      t.string :presentation

      t.timestamp
    end

    create_table :option_values_variants, :id => false, :force => true do |t|
      t.integer  :variant_id
      t.integer  :option_value_id
    end

    add_index :option_values_variants, :variant_id, :name => 'index_option_values_variants_on_variant_id'

    create_table :orders, :options => "ENGINE=INODB" do |t| 
      t.references :store 
      t.references :user
      t.string :number, :limit => 15
      t.decimal :item_total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :adjustment_total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.string :state
      t.decimal :credit_total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.decimal :payment_total, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.string :payment_state
      t.string :special_instructions, :limit => 150

      t.timestamps
      t.datetime :completed_at
    end 
    
    add_index :orders, :number, :name => 'index_orders_on_number' 

    create_table :products, :options => "ENGINE=INODB" do |t|
      t.references :store      
      t.string :sku
      t.string :name, :default => "", :null => false
      t.text :description
      t.decimal :price, :precision => 8, :scale => 2, :null => false
      t.string :meta_description
      t.string :meta_keywords

      t.datetime :deleted_at
      t.timestamps
    end

    create_table :product_option_types, :options => "ENGINE=INODB" do |t|
      t.integer :product_id
      t.integer :option_type_id
      t.integer :position

      t.timestamps
    end  

    create_table :product_properties, :force => true do |t|
      t.string   :value
      t.references :product
      t.references :property

      t.timestamps
    end

    create_table :products_taxons, :id => false, :force => true do |t|
      t.references :product
      t.references :taxon
    end

    add_index :products_taxons, :product_id, :name => 'index_products_taxons_on_product_id'
    add_index :products_taxons, :taxon_id, :name => 'index_products_taxons_on_taxon_id'

    create_table :properties, :options => "ENGINE=INODB" do |t|
      t.string   :name
      t.string   :presentation, :null => false

      t.timestamps
    end

    create_table :state_events, :options => "ENGINE=INODB" do |t|
      t.string     :name
      t.string     :previous_state
      t.references :stateful
      t.references :user
      t.string     :stateful_type
      t.string     :next_state
      t.timestamps
    end

    create_table :stores, :options => "ENGINE=INNODB" do |t|
      t.string :unique_id
      t.string :fanpage_id
      t.string :store_name
      t.string :store_description
      t.string :address
      t.string :email
      t.string :telephone
      t.string :url
      t.string :token
      t.string :latitude
      t.string :longitude
      t.string :manager_name
      t.string :manager_contact
      
      t.timestamps
    end

    create_table :stores_taxons, :id => false, :force => true do |t|
      t.references :store
      t.references :taxon
    end

    add_index :stores_taxons, :store_id, :name => 'index_stores_taxons_on_store_id'
    add_index :stores_taxons, :taxon_id, :name => 'index_stores_taxons_on_taxon_id'

    create_table :taxonomies, :force => true do |t|
      t.references :store 
      t.string   :name, :null => false

      t.timestamps
    end

    create_table :taxons, :options => "ENGINE=INODB" do |t|
      t.integer  :parent_id
      t.integer :lft
      t.integer :rgt 
      t.integer  :position,    :default => 0
      t.string   :name,        :null => false
      t.string   :permalink
      t.references :taxonomy

      t.timestamps
    end

    create_table :users, :options => "ENGINE=INODB" do |t|

      t.string :full_name

      t.string :provider,         :null => false, :default => ""
      t.string :uid,              :null => false, :default => ""
      t.integer :facebook_id

      t.string :username
      t.string :email,              :null => false, :default => ""
      t.string :encrypted_password, :null => false, :default => ""
      t.string :first_name
      t.string :last_name
      t.string :user_pin
      t.string :mobile_number
      t.datetime :birthday

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, :default => 0
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      ## Token authenticatable
      t.string :authentication_token

      t.references :profileable, :polymorphic => true

      # Uncomment below if timestamps were not included in your original model.
      t.timestamps
    end

    create_table :users_stores, :options => "ENGINE=INODB", :id => false do |t|
      t.references :user
      t.references :store
    end

    #User.create!(:store_id => 1, :email => 'shad6ster@gmail.com', :full_name => 'shadley', :username => 'sanjuro', :password => 'rad6hia', :password_confirmation => 'rad6hia')

    add_index :users, :email,                :unique => true
    add_index :users, :reset_password_token, :unique => true
    # add_index :users, :confirmation_token,   :unique => true
    # add_index :users, :unlock_token,         :unique => true
    # add_index :users, :authentication_token, :unique => true

    create_table :variants, :options => "ENGINE=INODB" do |t|
      t.references :product
      t.string   :sku,        :default => '', :null => false
      t.decimal  :price,      :precision => 8, :scale => 2,                    :null => false
      t.integer  :position,    :default => 0
      t.datetime :deleted_at
      t.boolean  :is_master,  :default => false
    end

    add_index :variants, :product_id, :name => 'index_variants_on_product_id'                    
  end
  
end
