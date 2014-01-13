require 'spec_helper'

describe ShippingMethod do
  include Rack::Test::Methods


  context "GIVEN we have a store that we want to make a store that can deliver" do

    before :each do   
      @store = Store.find(90)
      
    end

    it "SHOULD have its suburbs set to Zone 9, the delivery areas we offering" do 
  
    @Store.reindex
    Sunspot.commit

      # stores = [31,103,28,165,27,40,5,90,50,35,134,25,24,4,30,42,31]

      # stores.each do |store_id|
      #   puts 'id is %s'%store_id
      
      #   @store = Store.find(store_id)
      #   #set the store to be able to deliver
      #   @store.can_deliver = true
      #   @store.save
      #   zone = Zone.find(9)
        

      #   #craete the shipping method
      #   ship = ShippingMethod.new()
      #   ship.name = 'Delivery'
      #   ship.store = @store
      #   ship.zone = zone
      #   ship.shipping_method_type_id = '2'      
      #   #create zonal charging system
      #   zoneRate = Calculator::ZoneRate.new()
      #   ship.calculator = zoneRate    

      #   deliveryZoneRate = ZonesRates.new()
      #   deliveryZoneRate.zone = zone
      #   deliveryZoneRate.store = @store
      #   deliveryZoneRate.rate = 10

      #   ship.save
      #   zoneRate.save
      #   zone.save
      #   deliveryZoneRate.save
        
      #   #add it to the existing zone that has a R10 delivery fee
      #   puts 'ship name = %s'%ship.name
      #   result = ship.save!()
      #   puts 'ship id %s' % result
      # end
      # 1.should == 1 

    end


    # it "SHOULD add a variant with the special instructions included" do
    #   sp_variant = Variant.find(5)
    #   special_instructions = 'this is a special instruction'
    #   @order.add_variant(sp_variant, 1,'this is a special instruction')
    #   rel_line_item = @order.find_line_item_by_variant(sp_variant,special_instructions)
    #   puts 'si -> %s'%rel_line_item.special_instructions
    #   rel_line_item.special_instructions.should == special_instructions
      
    #end


    
  end

end








