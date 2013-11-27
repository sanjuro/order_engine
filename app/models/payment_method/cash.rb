class Cash < PaymentMethod
  def actions
    %w{capture void}
  end

  def create_profile(profile_details)
    return_data = Hash.new
    return_data = {
                    :hash_value => "",
                    :secured_card_info => "",
                  }
  end

  def authorize(options)
  end

  def purchase(options)
  end

  # Indicates whether its possible to capture the payment
  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end

  # Indicates whether its possible to void the payment.
  def can_void?(payment)
    payment.state != 'void'
  end

  def capture(*args)
    ActiveMerchant::Billing::Response.new(true, "", {}, {})
  end

  def void(*args)
    ActiveMerchant::Billing::Response.new(true, "", {}, {})
  end

  def source_required?
    false
  end
end
