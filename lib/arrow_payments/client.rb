module ArrowPayments
  class Client
    include ArrowPayments::Connection
    include ArrowPayments::Customers
    include ArrowPayments::PaymentMethods
    include ArrowPayments::Transactions

    attr_reader :api_key, :mode, :merchant_id

    # Initialize a new client instance
    # @param [Hash] client connection options
    # 
    # Available options:
    #
    #   :api_key - Your API key (required)
    #   :mode - API mode (sandox / production)
    #   :merchant_id - Your merchant ID 
    #
    def initialize(options={})
      @api_key     = options[:api_key] || ArrowPayments::Configuration.api_key
      @mode        = (options[:mode] || ArrowPayments::Configuration.mode || 'production').to_s
      @merchant_id = options[:merchant_id] || ArrowPayments::Configuration.merchant_id

      if api_key.to_s.empty?
        raise ArgumentError, "API key required"
      end

      unless %(sandbox production).include?(mode)
        raise ArgumentError, "Invalid mode: #{mode}"
      end
    end

    # Check if client is in sandbox mode
    # @return [Boolean]
    def sandbox?
      mode == 'sandbox'
    end

    # CHeck if client is in production mode
    # @return [Boolean]
    def production?
      mode == 'production'
    end
  end
end