require "arrow_payments/version"
require "arrow_payments/errors"

module ArrowPayments
  autoload :Address, "arrow_payments/address"
  autoload :Client, "arrow_payments/client"
  autoload :Configuration, "arrow_payments/configuration"
  autoload :Connection, "arrow_payments/connection"
  autoload :Customer, "arrow_payments/customer"
  autoload :Customers, "arrow_payments/client/customers"
  autoload :Entity, "arrow_payments/entity"
  autoload :LineItem, "arrow_payments/line_item"
  autoload :PaymentMethod, "arrow_payments/payment_method"
  autoload :PaymentMethods, "arrow_payments/client/payment_methods"
  autoload :RecurringBilling, "arrow_payments/recurring_billing"
  autoload :Transaction, "arrow_payments/transaction"
  autoload :Transactions, "arrow_payments/client/transactions"

  class << self
    def client(options=nil)
      options ||= {}
      ArrowPayments::Client.new(options)
    end
  end
end
