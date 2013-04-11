# Class to model the order resource
#
# Author::    Shadley Wentzel
class Order < ActiveRecord::Base
  
  STATUS_CART = 'cart'
  STATUS_CONFIRM = 'confirm'
  STATUS_COMPLETE = 'complete'
  
  attr_accessible :store_id, :line_items, :bill_address_attributes, :ship_address_attributes, :payments_attributes, :invoice_attributes, 
                  :line_items_attributes, :number, :item_total, :total, :state, :credit_total, :user_id, :is_delivery, 
                  :payment_total, :payment_state, :shipment_state, :special_instructions, :shipping_method_id, :device_identifier, :store_order_number,
                  :time_to_ready, :device_type, :adjustment_total, :created_at, :completed_at, :updated_at
                  
  validates :number, :uniqueness => true, :on => :create
                 
  belongs_to :store
  belongs_to :customer, :foreign_key => "user_id", :class_name => "Customer"

  belongs_to :ship_address, :foreign_key => :ship_address_id, :class_name => "Address"
  alias_attribute :shipping_address, :ship_address

  belongs_to :shipping_method  

  # has_one :invoice
  # has_one :master,
  #     :class_name => "Variant",
  #     :conditions => { :is_master => true }

  has_many :state_events, :as => :stateful
  has_many :line_items, :dependent => :destroy, :order => "created_at ASC"
  has_many :shipments, :dependent => :destroy do
    def states
      pluck(:state).uniq
    end
  end
  # has_many :payments, :dependent => :destroy
  has_many :adjustments, :as => :adjustable, :dependent => :destroy, :order => "created_at ASC"

  accepts_nested_attributes_for :line_items
  accepts_nested_attributes_for :ship_address
  # accepts_nested_attributes_for :invoice
  # accepts_nested_attributes_for :payments
  accepts_nested_attributes_for :shipments
  
  # before_create :create_client
  before_create :generate_order_number  
  
  scope :by_number, lambda {|number| where("orders.number = ?", number)}
  scope :by_store, lambda {|store| where("orders.store_id = ?", store)} 
  scope :by_state, lambda {|state| where("orders.state = ?", state)}
  scope :sent_to_store,  where("orders.state = 'sent_store'")
  scope :by_user, lambda {|store| where("orders.user_id = ?", store)} 
  scope :created_on, lambda {|date| {:conditions => ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day]}}
  scope :updated_on, lambda {|date| {:conditions => ['updated_at >= ? AND updated_at <= ?', date.beginning_of_day, date.end_of_day]}}

  # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
  state_machine :initial => :cart, :use_transactions => false do
  
    event :next do
      transition :from => :cart, :to => :delivery_confirm
      transition :from => :delivery_confirm, :to => :address
      transition :from => :address, :to => :delivery
      transition :from => :delivery, :to => :confirm
      transition :from => :confirm, :to => :sent_store
      transition :from => :sent_store, :to => :store_received
      transition :from => :store_received, :to => :in_progress
      transition :from => :in_progress, :to => :ready
      transition :from => :ready, :to => :collected
    end
   
    event :cancel do
      transition :to => :canceled, :if => :allow_cancel?
    end

    event :no_delivery do
      transition :delivery_confirm => :delivery
    end

    event :choose_delivery do
      transition :to => :delivery, :unless => :is_delivery_order
    end

    event :collect do
      transition :to => :collected
    end

    event :no_collect do
      transition :to => :not_collected
    end


    before_transition :to => :collected do |order|
      begin
        # order.process_payments!

        order.process_line_items! 

      rescue Core::GatewayError
        if Spree::Config[:allow_checkout_on_gateway_error]
          true
        else
          false
        end
      end
    end

    after_transition :to => :sent_store do |order|
      order.finalize!
    end

    before_transition :to => :in_progress do |order|
      # notify customer of in_progress wiht time
      order.send_in_progress_nofitication
    end

    after_transition :to => :ready do |order|
      # notify customer of impending delivery
    end

    after_transition :to => :cancelled do |order|
      # notify customer of impending delivery
    end
    
    # after_transition :to => 'delivery', :do => :create_tax_charge!
    after_transition :to => :confirm, :do => :create_shipment!, :if => :is_delivery_order

  end 

  # Function to count the numbder of orders on a specific date
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def self.count_on(date)
    where("date(created_at) = ?",date).count(:id)
  end

  # Function to total the value of orders per month
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def self.value_per_month(date)
    where("date(created_at) >= ?", date).where("date(created_at) < ?", date + 1.month).sum(:total)
  end

  # Function to generate a new order number
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def generate_order_number
    record = true
    while record
      random = "R#{Array.new(9){rand(9)}.join}"
      record = self.class.where(:number => random).first
    end
    self.number = random if self.number.blank?
    self.number
  end


  # Function to send the order read notificaiton
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def send_ready_notification

  end

  def is_delivery_order
    self.is_delivery
  end

  def ship_total
    adjustments.shipping.map(&:amount).sum
  end

  # Associates the specified user with the order.
  def associate_user!(user)
    self.user = user
    # disable validations since they can cause issues when associating
    # an incomplete address during the address step
    save(:validate => false)
  end

  def completed?
    !! completed_at
  end
  
  def status_tag
    case self.state
      when STATUS_CART then :error
      when STATUS_SENT_STORE then :warning
      when STATUS_COMPLETE then :ok
    end
  end 

  def find_line_item_by_variant(variant)
    line_items.detect { |line_item| line_item.variant_id == variant.id }
  end

  def allow_cancel?
    return false unless completed? and state != 'canceled'
    %w{ready backorder pending}.include? shipment_state
  end

  def allow_resume?
    # we shouldn't allow resume for legacy orders b/c we lack the information necessary to restore to a previous state
    return false if state_changes.empty? || state_changes.last.previous_state.nil?
    true
  end

  def add_variant(variant, quantity = 1, special_instructions)
    current_item = find_line_item_by_variant(variant)
    if current_item
      current_item.quantity += quantity
      current_item.special_instructions = special_instructions
      current_item.save
    else
      current_item = LineItem.new(:quantity => quantity)
      current_item.variant = variant
      current_item.price   = variant.price
      current_item.special_instructions = special_instructions
      self.line_items << current_item
    end

    self.reload
    current_item
  end

  # This is a multi-purpose method for processing logic related to changes in the Order.  It is meant to be called from
  # various observers so that the Order is aware of changes that affect totals and other values stored in the Order.
  # This method should never do anything to the Order that results in a save call on the object (otherwise you will end
  # up in an infinite recursion as the associations try to save and then in turn try to call +update!+ again.)
  def update!
    update_totals
    # update_payment_state

    shipments.each { |shipment| shipment.update!(self) }#(&:update!)
    update_shipment_state
    update_adjustments   

    # give each of the shipments a chance to update themselves
    # update totals a second time in case updated adjustments have an effect on the total
    update_totals

    update_attributes({
      :payment_state => payment_state,
      :item_total => item_total,
      :adjustment_total => adjustment_total,
      :payment_total => payment_total,
      :total => total
    })

  end

  # Function to process payments
  #
  # * *Args*    :
  #   - 
  # * *Returns* :
  #   - 
  # * *Raises* :
  #   - 
  #
  def process_payments!
    ret = payments.each(&:process!)
  end

  def get_line_items_with_variant_info
    order_line_items = Array.new

    line_items.each do |line_item|
      order_line_item = line_item
      order_line_item[:name] = line_item.variant.name
      order_line_item[:description] = line_item.variant.description
      order_line_item[:sku] = line_item.variant.sku
      order_line_item[:option_values] = line_item.variant.options_text 
      order_line_items << order_line_item
    end

    return order_line_items
  end

  # Indicates whether or not the user is allowed to proceed to checkout.  Currently this is implemented as a
  # check for whether or not there is at least one LineItem in the Order.  Feel free to override this logic
  # in your own application if you require additional steps before allowing a checkout.
  def checkout_allowed?
    line_items.count > 0
  end

  def has_step?(step)
    checkout_steps.include?(step)
  end

  def checkout_steps
    checkout_steps = [ :cart, :delivery_confirm, :address, :delivery, :confirm, :sent_store, :complete]

    ## TODO: replace this with each_with_object once Ruby 1.9 is standard
    # self.state_paths.to_states.each do |step, options|
    #   checkout_steps << step
    # end
    checkout_steps.map(&:to_s)
  end

  def payment?
    false
  end

  def empty!
    line_items.destroy_all
    adjustments.destroy_all
  end

  def state_changed(name)
    state = "#{name}_state"
    if persisted?
      old_state = self.send("#{state}_was")
        StateEvent.create({
          :previous_state => old_state,
          :next_state => self.send(state),
          :name => name,
          :user_id => self.user_id,
          :stateful_id => self.id,
          :stateful_type => 'order'
        })
    end
  end


  # convenience method since many stores will not allow user to create multiple shipments
  def shipment
    @shipment ||= shipments.last
  end

  # Creates a new shipment (adjustment is created by shipment model)
  def create_shipment!
    shipping_method(true)

    if shipment.present?
       shipment.update_attributes!(:shipping_method => shipping_method)
    else
      self.shipments << Shipment.create!({ :order => self,
                                        :shipping_method => shipping_method,
                                        :address => self.ship_address}, :without_protection => true)
   end
  end

  def name
    if (address = bill_address || ship_address)
      "#{address.firstname} #{address.lastname}"
    end
  end

  def can_ship?
    self.complete?
  end 

  # Helper methods for checkout steps

  def available_shipping_methods(display_on = nil)
    return [] unless ship_address
    ShippingMethod.all_available(self, display_on)
  end

  def rate_hash
    @rate_hash ||= available_shipping_methods(:front_end).collect do |ship_method|
      next unless cost = ship_method.calculator.compute(self)
      ShippingRate.new( :id => ship_method.id,
                        :shipping_method => ship_method,
                        :name => ship_method.name,
                        :cost => cost)
    end.compact.sort_by { |r| r.cost }
  end

  # destroy any previous adjustments.
  # Adjustments will be recalculated during order update.
  def clear_adjustments!
    adjustments.tax.each(&:destroy)
    price_adjustments.each(&:destroy)
  end

  def process_line_items!
    # ret = order_items.each(&:process!)

    # calculate reward points
    total_reward_points = 0
    line_items.each do |item|
       total_reward_points += item.variant.product.reward_points 
    end

    reward_point_level = RewardPoint.new(:user_id => self.user_id,
                                      :total_points => total_reward_points,
                                      :is_current => 1,
                                      :created_at => Time.zone.now                         
                                      )
    inventory_level.save
    
    # line_items.each do |item|
    #   ret = item.process!
    #   self.line_items.delete(item) if ret == false
    # end
    
  end

  # Finalizes an in progress order after checkout is complete.
  # Called after transition to complete state when payments will have been processed
  def finalize!
    touch :completed_at
    # InventoryUnit.assign_opening_inventory(self)

    # lock all adjustments (coupon promotions, etc.)
    # adjustments.each { |adjustment| adjustment.update_column('state', "closed") }

    # update payment and shipment(s) states, and save
    # update_payment_state
    shipments.each { |shipment| shipment.update!(self) }
    update_shipment_state
    save

    send_new_order_notification

    deliver_order_confirmation_email(self.customer.email)

    logger.info "Order Id:#{self.id}Sent user confirmation email."

    self.state_events.create({
      :previous_state => 'confirm',
      :next_state     => 'sent_store',
      :name           => 'order' ,
      :user_id        => self.user_id
    }, :without_protection => true)
  end

  def deliver_order_confirmation_email(recipient)
    begin
      OrderMailer.order_confirmation(self,recipient).deliver
    rescue Exception => e
      logger.error("#{e.class.name}: #{e.message}")
      logger.error(e.backtrace * "\n")
    end
  end

  def send_new_order_notification

    Notification.adapter = 'android'

    message = Hash.new
    message[:order_id] = self.id
    message[:msg] = "new"

    devices_stored = Array.new

    # get all devices for the store
    self.store.devices.each do |device|
      devices_stored << device.device_token
    end

    Notification.send(devices_stored, message)

    p "Order Id:#{self.id}Sent store notification to In-Store Application."

  end

  def send_in_progress_nofitication

    message = Hash.new
    message[:order_id] = self.id
    message[:msg] = "Your order: #{self.number} has been received and will be ready in #{self.time_to_ready} minutes."

    device = Device.find_by_device_identifier(self.device_identifier).first

    devices = Array.new

    # get all devices for the store
    devices << device.device_token

    logger.info "Order Id:#{self.id}Sent in progress notification." 

    Notification.adapter = self.device_type

    Notification.send(devices, message)
  end

  def send_ready_nofitication

    message = Hash.new
    message[:order_id] = self.id
    message[:msg] = "Your order: #{self.number} is ready for collection at #{self.store.store_name}."

    device = Device.find_by_device_identifier(self.device_identifier).first

    devices = Array.new

    # get all devices for the store
    # devices << "APA91bFX-US6bO_4AvYJNM5_cLf-v7klAqRob-9o8N13plxBBQutteXFnTbc8JbYvligGZRanJl8OYqcqOOlszHpRDW-It5SpfqdIfHDAPA63EdVqU7oX2W8zCZI3JDoEgLG5gFeTIC0qVl8iQw8KmYSEZXwJDmC_g"
    devices << device.device_token

    logger.info "Order Id:#{self.id}Sent ready notification." 

    Notification.adapter = self.device_type

    Notification.send(devices, message)
  end

  def format_for_web_serivce
    orders_return = Hash.new

    orders_return = { 
            "adjustment_total" => self.adjustment_total,
            "completed_at" => self.completed_at,
            "created_at" => self.created_at,
            "credit_total" => self.credit_total,
            "id" => self.id,
            "item_total" => self.item_total,
            "number" => self.number,
            "payment_state" => self.payment_state,
            "payment_total" => self.payment_total,
            "special_instructions" => self.special_instructions,
            "time_to_ready" => self.time_to_ready,
            "state" => self.state,
            "store_id" => self.store_id,
            "store_order_number" => self.store_order_number,
            "total" => self.total,
            "updated_at" => self.updated_at,
            "user" => { 
                "full_name" => self.customer.full_name,
                "first_name" => self.customer.first_name,
                "last_name" => self.customer.last_name,
                "email" => self.customer.email,
                "mobile_number" => self.customer.mobile_number,
                },
            "line_items" => self.get_line_items_with_variant_info
    }

  end

  private

      def link_by_email
        self.email = user.email if self.user
      end

      # Updates the +payment_state+ attribute according to the following logic:
      #
      # paid          when +payment_total+ is equal to +total+
      # balance_due   when +payment_total+ is less than +total+
      # credit_owed   when +payment_total+ is greater than +total+
      # failed        when most recent payment is in the failed state
      #
      # The +payment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
      def update_payment_state
        
        #line_item are empty when user empties cart
        if self.line_items.empty? || round_money(payment_total) < round_money(total)
          self.payment_state = 'balance_due'
          self.payment_state = 'failed' if payments.present? and payments.last.state == 'failed'
        elsif round_money(payment_total) > round_money(total)
          self.payment_state = 'credit_owed'
        else
          self.payment_state = 'paid'
        end

        if old_payment_state = self.changed_attributes['payment_state']
          self.state_changes.create({
            :previous_state => old_payment_state,
            :next_state     => self.payment_state,
            :name           => 'payment',
            :user_id        => self.user_id
          }, :without_protection => true)
        end
      end

      def round_money(n)
        (n*100).round / 100.0
      end

      # Updates the following Order total values:
      #
      # +payment_total+      The total value of all finalized Payments (NOTE: non-finalized Payments are excluded)
      # +item_total+         The total value of all LineItems
      # +adjustment_total+   The total value of all adjustments (promotions, credits, etc.)
      # +total+              The so-called "order total."  This is equivalent to +item_total+ plus +adjustment_total+.
      def update_totals
        # update_adjustments
        # self.payment_total = payments.completed.map(&:amount).sum
        self.item_total = line_items.map(&:amount).sum
        self.adjustment_total = adjustments.eligible.map(&:amount).sum
        self.total = item_total + adjustment_total
      end

      # Updates each of the Order adjustments.  This is intended to be called from an Observer so that the Order can
      # respond to external changes to LineItem, Shipment, other Adjustments, etc.
      # Adjustments will check if they are still eligible. Ineligible adjustments are preserved but not counted
      # towards adjustment_total.
      def update_adjustments
        self.adjustments.reload.each { |adjustment| adjustment.update!(self) }
      end


      # Updates the +shipment_state+ attribute according to the following logic:
      #
      # shipped   when all Shipments are in the "shipped" state
      # partial   when at least one Shipment has a state of "shipped" and there is another Shipment with a state other than "shipped"
      #           or there are InventoryUnits associated with the order that have a state of "sold" but are not associated with a Shipment.
      # ready     when all Shipments are in the "ready" state
      # backorder when there is backordered inventory associated with an order
      # pending   when all Shipments are in the "pending" state
      #
      # The +shipment_state+ value helps with reporting, etc. since it provides a quick and easy way to locate Orders needing attention.
      def update_shipment_state
        # get all the shipment states for this order
        shipment_states = shipments.states
        if shipment_states.size > 1
          # multiple shiment states means it's most likely partially shipped
          self.shipment_state = 'partial'
        else
          # will return nil if no shipments are found
          self.shipment_state = shipment_states.first
          if self.shipment_state
            # shipments exist but there are unassigned inventory units
            self.shipment_state = 'partial'
          end
        end

        self.state_changed('shipment')
      end

end