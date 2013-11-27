# Class to model a gateway method
#
# Author::    Shadley Wentzel
require File.dirname(__FILE__) +  '/payment_method.rb'
class Gateway < PaymentMethod
    delegate_belongs_to :provider, :authorize, :purchase, :capture, :void, :credit
    # delegate_attributes :authorize, :purchase, :capture, :void, :credit, :to => :provider

    validates :name, :type, :presence => true

    # preference :server, :string, :default => 'test'
    # preference :test_mode, :boolean, :default => true

    attr_accessible :preferred_server, :preferred_test_mode

    def provider
      gateway_options = options
      # gateway_options.delete :login if gateway_options.has_key?(:login) and gateway_options[:login].nil?
     
      @provider ||= provider_class.new(gateway_options)
    end

    def payment_source_class
      CreditCard
    end

    # instantiates the selected gateway and configures with the options stored in the database
    def self.current
      super
    end

    def options
      self.preferences.inject({}){ |memo, (key, value)| memo[key.to_sym] = value; memo }
    end

    def method_missing(method, *args)
      if @provider.nil? || !@provider.respond_to?(method)
        super
      else
        provider.send(method)
      end
    end

    def payment_profiles_supported?
      false
    end

    def method_type
      'gateway'
    end
end