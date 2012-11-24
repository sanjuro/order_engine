# Class to model the order resource
#
# Author::    Shadley Wentzel
class Order < ActiveRecord::Base

  STATUS_CART = 'cart'
  STATUS_CONFIRM = 'confirm'
  STATUS_COMPLETE = 'complete'
  
  attr_accessible :store_id, :order_items, :bill_address_attributes, :payments_attributes, :invoice_attributes, 
                  :order_items_attributes, :number, :item_total, :total, :state, :credit_total, :customer_id,
                  :payment_total, :payment_state, :special_instructions,
                  :created_at, :completed_at, :updated_at
                  
  validates :number, :uniqueness => true, :on => :create
                 
  belongs_to :store
  belongs_to :customer, :foreign_key => "customer_id", :class_name => "Customer"
  # belongs_to :bill_address, :foreign_key => "bill_address_id", :class_name => "Address"
  
  # has_one :invoice

  has_many :state_changes, :as => :stateful
  has_many :line_items, :dependent => :destroy, :order => "created_at ASC"
  # has_many :payments, :dependent => :destroy

  accepts_nested_attributes_for :line_items
  # accepts_nested_attributes_for :invoice
  # accepts_nested_attributes_for :payments
  
  # before_create :create_client
  before_create :generate_order_number  
  
  scope :by_number, lambda {|number| where("orders.number = ?", number)}
  scope :by_store, lambda {|store| where("orders.store_id = ?", store)} 

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

  # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
  state_machine :initial => :cart, :use_transactions => false do
  
    event :next do
      transition :from => :cart, :to => :confirm
      transition :from => :confirm, :to => :sent_store
      transition :from => :sent_store, :to => :ready
      transition :from => :ready, :to => :collected
      transition :from => :collected, :to => :complete
    end

    event :prdduce_order do
      transition :to => :complete, :if => :allow_cancel?
    end
   
    event :cancel do
      transition :to => :canceled, :if => :allow_cancel?
    end

    before_transition :to => :sent_store do |order|
      # order.process_payments! # process payments
      order.process_line_items! # fetch products
    end

    after_transition :to => :complete do |order|
      # notify customer of order

    end
    
    # after_transition :to => 'delivery', :do => :create_tax_charge!
    # after_transition :to => 'payment', :do => :create_shipment!

  end 
  
  def status_tag
    case self.state
      when STATUS_CART then :error
      when STATUS_SENT_STORE then :warning
      when STATUS_COMPLETE then :ok
    end
  end 

end