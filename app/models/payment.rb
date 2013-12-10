class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :source, :polymorphic => true, :validate => true
  belongs_to :payment_method

  has_many :offsets, :class_name => "Payment", :foreign_key => :source_id, :conditions => "source_type = 'Payment' AND amount < 0 AND state = 'completed'"
  has_many :log_entries, :as => :source

  # after_save :create_payment_profile, :if => :profiles_supported?

  # update the order totals, etc.
  # after_save :update_order

  attr_accessor :source_attributes
  after_initialize :build_source

  attr_accessible :amount, :payment_method_id, :source_attributes, :source_id, :source_type

  scope :from_credit_card, lambda { where(:source_type => 'CreditCard') }
  scope :with_state, lambda { |s| where(:state => s) }
  scope :completed, with_state('completed')
  scope :pending, with_state('pending')
  scope :failed, with_state('failed')

  # order state machine (see http://github.com/pluginaweek/state_machine/tree/master for details)
  state_machine :initial => 'checkout' do
    # With card payments, happens before purchase or authorization happens
    event :started_processing do
      transition :from => ['checkout', 'pending', 'completed', 'processing'], :to => 'processing'
    end
    # When processing during checkout fails
    event :failure do
      transition :from => ['pending', 'processing'], :to => 'failed'
    end
    # With card payments this represents authorizing the payment
    event :pend do
      transition :from => ['checkout', 'processing'], :to => 'pending'
    end
    # With card payments this represents completing a purchase or capture transaction
    event :complete do
      transition :from => ['processing', 'pending', 'checkout'], :to => 'completed'
    end
    event :void do
      transition :from => ['pending', 'completed', 'checkout'], :to => 'void'
    end
  end

  def currency
    order.currency
  end

  def display_amount
    amount
  end

  def offsets_total
    offsets.map(&:amount).sum
  end

  def credit_allowed
    amount - offsets_total
  end

  def can_credit?
    credit_allowed > 0
  end

  # see https://github.com/spree/spree/issues/981
  def build_source
    return if source_attributes.nil?
    if payment_method and payment_method.payment_source_class
      self.source = payment_method.payment_source_class.new(source_attributes)
    end
  end

  def payment_source
    res = source.is_a?(Payment) ? source.source : source
    res || payment_method
  end


  def gateway_options
    options = { :email    => order.email,
                :customer => order.email,
                :ip       => order.last_ip_address,
                :order_id => order.number }

    options.merge!({ :shipping => order.ship_total * 100,
                     :tax      => order.tax_total * 100,
                     :subtotal => order.item_total * 100 })

    options.merge!({ :currency => currency })

    options.merge!({ :billing_address  => order.bill_address.try(:active_merchant_hash),
                    :shipping_address => order.ship_address.try(:active_merchant_hash) })

    options.merge!(:discount => promo_total) if respond_to?(:promo_total)
    options
  end

  private

    def update_order
      order.payments.reload
      order.update!
    end

end