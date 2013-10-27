class AddClub < ActiveRecord::Migration
  
	 def self.up
	    create_table :clubs, :options => "ENGINE=INODB" do |t|
      		t.references :store
     		t.string   :club_name
     		t.string   :club_description
            t.string   :address
            t.string   :latitude
            t.string   :longitude
     		t.string   :tagline
     		t.string   :tag
     		t.boolean  :is_active,  :default => true

      		t.timestamps
	    end

        create_table :deals_users, :options => "ENGINE=INODB" do |t|
            t.integer  :id
            t.references :deal
            t.references :user
            t.boolean  :is_redeem,  :default => false

            t.timestamps
        end

	    add_column :deals, :prize, :string
        add_column :deals, :time_frame, :string
        add_column :deals, :club_id, :integer
        add_column :deals, :redeem_code, :string

        add_column :loyalties, :redeem_code, :string
        add_column :loyalties, :club_id, :integer
	end

	def self.down
    	drop_table :clubs

    	remove_column :deals, :prize
    	remove_column :deals, :time_frame
        remove_column :deals, :club_id
        remove_column :deals, :redeem_code

        remove_column :loyalties, :redeem_code
        remove_column :loyalties, :club_id
	end
end