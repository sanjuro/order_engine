class AddSpecialInstructionsToLineItems < ActiveRecord::Migration

	def self.up
		add_column :line_items, :special_instructions, :string
	end

	def self.down
    	remove_column :line_items, :special_instructions
    end
end