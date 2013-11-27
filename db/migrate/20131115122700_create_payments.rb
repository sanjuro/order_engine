class CreatePayments < ActiveRecord::Migration

  def up

    create_table :gateways do |t|
      t.string     :type
      t.string     :name
      t.text       :description
      t.boolean    :active,      :default => true
      t.string     :environment, :default => 'development'
      t.string     :server,      :default => 'test'
      t.boolean    :test_mode,   :default => true
      t.timestamps
    end

    create_table :credit_cards do |t|
      t.string     :month
      t.string     :year
      t.string     :cc_type
      t.string     :last_digits
      t.string     :first_name
      t.string     :last_name
      t.string     :start_month
      t.string     :start_year
      t.string     :issue_number
      t.references :address
      t.string     :gateway_customer_profile_id
      t.string     :gateway_payment_profile_id
      t.timestamps
    end

    create_table :payments do |t|
      t.decimal    :amount, :precision => 8, :scale => 2, :default => 0.0, :null => false
      t.references :order
      t.references :source, :polymorphic => true
      t.references :payment_method
      t.string     :payment_data
      t.string     :state
      t.string     :response_code
      t.string     :avs_response
      t.timestamps
    end

    create_table :payment_methods do |t|
      t.string     :gateway_type
      t.string     :name
      t.text       :description
      t.boolean    :active,      :default => true
      t.string     :environment, :default => 'development'
      t.datetime   :deleted_at
      t.string     :display_on
      t.timestamps
    end


    add_column :users, :payment_method_id, :integer, :default => 1

  end

  def self.down
    drop_table :gateways 
    drop_table :credit_cards
    drop_table :payments
    drop_table :payment_methods

  end

end