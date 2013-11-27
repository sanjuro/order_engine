class StandardBankCreditCard < Gateway
  include StandardBankHelper
  
  TEST_VISA = '4111111111111111'
  TEST_MC   = '5500000000000004'
  TEST_AMEX = '340000000000009'
  TEST_DISC = '6011000000000004'

  VALID_CCS = ['1', TEST_VISA, TEST_MC, TEST_AMEX, TEST_DISC]

  attr_accessor :test

  def provider_class
    self.class
  end

  def preferences
    {}
  end

  def create_profile(profile_details)
    # create a session with the payment gateway
    session_data = create_channel_session

    # generate the unique payment profile
    payment_data = register_card(session_data, profile_details)    
  end

  def authorize(options)
    # create a session with the payment gateway
    session_data = create_channel_session
    
    # For testing
    transaction_options = Hash.new
    transaction_options = {
          :payment_type => options[:payment_type],
          :amount => options[:amount],
          :merchant_id => options[:merchant_id]
    }
    
    payment_guid = start_payment_process(session_data, transaction_options)
    
  end

  def purchase(options)
    # create a session with the payment gateway
    session_data = create_channel_session

    # For testing
    transaction_options = Hash.new
    transaction_options = {
          :guid => options[:guid],
          :encrypted_card_info => options[:encrypted_card_info],
          :card_hash => options[:card_hash]
    }
    
    payment_guid = complete_payment_process(session_data, transaction_options)
  end

  def credit(money, credit_card, response_code, options = {})
    ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '12345')
  end

  def capture(authorization, credit_card, gateway_options)
    if authorization.response_code == '12345'
      ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '67890')
    else
      ActiveMerchant::Billing::Response.new(false, 'Bogus Gateway: Forced failure', :error => 'Bogus Gateway: Forced failure', :test => true)
    end

  end

  def void(response_code, credit_card, options = {})
    ActiveMerchant::Billing::Response.new(true, 'Bogus Gateway: Forced success', {}, :test => true, :authorization => '12345')
  end

  def test?
    # Test mode is not really relevant with bogus gateway (no such thing as live server)
    true
  end

  def payment_profiles_supported?
    true
  end

  def actions
    %w(capture void credit)
  end

  private
    def generate_profile_id(success)
      record = true
      prefix = success ? 'BGS' : 'FAIL'
      while record
        random = "#{prefix}-#{Array.new(6){rand(6)}.join}"
        record = CreditCard.where(:gateway_customer_profile_id => random).first
      end
      random
    end
end