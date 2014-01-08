require 'spec_helper'

describe Order do
  include Rack::Test::Methods


  context "GIVEN we are adding a varient to an order" do

    before :each do   
  	  @order = Order.find(2678)
  	  @variant = Variant.find(23)
	  end

  	it "SHOULD add a varient to the order" do 
  
  	  @order.add_variant(@variant)
  	  rel_line_item = @order.find_line_item_by_variant(@variant,'')
      puts 'rel line item %s'%rel_line_item.variant.id
  	  rel_line_item.variant_id.should == @variant.id

        
    end


    it "SHOULD add a variant with the special instructions included" do
      sp_variant = Variant.find(5)
      special_instructions = 'this is a special instruction'
      @order.add_variant(sp_variant, 1,'this is a special instruction')
      rel_line_item = @order.find_line_item_by_variant(sp_variant,special_instructions)
      puts 'si -> %s'%rel_line_item.special_instructions
      rel_line_item.special_instructions.should == special_instructions
      
    end


  	
  end

end








