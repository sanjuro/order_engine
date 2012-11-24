class OptionValue < ActiveRecord::Base
	belongs_to :option_type
	acts_as_list :scope => :option_type
	has_and_belongs_to_many :variants, :join_table => 'option_values_variants', :class_name => "Variant"

	attr_accessible :name, :presentation
end
