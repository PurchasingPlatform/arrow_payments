require "arrow_payments/version"
require "arrow_payments/errors"

module ArrowPayments
  autoload :Address
  autoload :Client
  autoload :Configuration
  autoload :Connection
  autoload :Customer
  autoload :Customers
  autoload :Entity
  autoload :LineItem
  autoload :PaymentMethod
  autoload :PaymentMethods
  autoload :RecurringBilling
  autoload :Transaction
  autoload :Transactions

  class << self
    def client(options=nil)
      options ||= {}
      ArrowPayments::Client.new(options)
    end
  end
end
