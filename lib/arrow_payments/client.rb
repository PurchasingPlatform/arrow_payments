module ArrowPayments
  class Client
    include ArrowPayments::Connection
    include ArrowPayments::Customers
    include ArrowPayments::PaymentMethods
    include ArrowPayments::Transactions

    attr_reader :api_key, :mode, :merchant_id, :debug

    def initialize(options=nil)
      options ||= {}
      @api_key     = options[:api_key] || config(:api_key)
      @mode        = options[:mode] || config(:mode) || "production"
      @merchant_id = options[:merchant_id] || config(:merchant_id)
      @debug       = options[:debug] || config(:debug) || true

      raise ArgumentError, "API key required" unless api_key
      raise ArgumentError, "Merchant ID required" unless merchant_id
      raise ArgumentError, "Invalid mode: #{mode}" unless %(sandbox production).include?(mode)
    end

    def sandbox?
      mode == "sandbox"
    end

    def production?
      mode == "production"
    end

    def debug?
      debug == true
    end

    private

    def config(option)
      ArrowPayments::Configuration.send(option)
    end
  end
end