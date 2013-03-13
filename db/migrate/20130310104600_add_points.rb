class AddPoints< ActiveRecord::Migration

	def self.up
	    create_table :reward_points do |t|
	      t.references 	:users
	      t.integer    	:total_points    
	      t.boolean    	:is_current, :default => true

	      t.timestamps
	    end

	    add_column :orders, :reward_points_gained, :integer
	    add_column :orders, :reward_points_lost, :integer
		add_column :products, :reward_points, :integer
	end

	def self.down
    	drop_table :reward_points

	    remove_column :orders, :reward_points_gained, :integer
	    remove_column :orders, :reward_points_lost, :integer
		remove_column :products, :reward_points, :integer
    end
end