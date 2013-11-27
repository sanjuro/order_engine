class CreatePaymentProfiles < ActiveRecord::Migration

  	def up
      create_table :payment_profiles do |t|
	      t.references :user
	      t.references :payment_method
	      t.string 	   :unique_token
	      t.string     :payment_data
	      t.string     :is_active
	      t.timestamps
	    end
	end

	def self.down
		drop_table :payment_profiles 
	end

end