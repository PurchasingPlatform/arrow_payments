module ArrowPayments
  module Transactions
    # Get transaction details
    # @param [String] transaction ID
    # @return [Transaction] transactions instance
    def transaction(id)
      Transaction.new(get("/transaction/#{id}"))
    rescue NotFound
      nil
    end

    # Get customer transactions by status
    # @param [String] customer ID
    # @param [String] transaction status
    # @return [Array<Transaction>]
    def transactions(customer_id, status='NotSettled')
      unless Transaction::STATUSES.include?(status)
        raise ArgumentError, "Invalid status: #{status}"
      end

      resp = get("/customer/#{customer_id}/Transactions/#{status}")
      resp['Transactions'].map { |t| Transaction.new(t) }
    end

    # Capture an unsettled transaction
    # @param [String] transaction ID
    # @param [Integer] amount, less than or equal to original amount
    # @return [Boolean]
    def capture_transaction(id, amount)
      resp = post('/transaction/capture', 'TransactionId' => id, 'Amount' => amount)
      resp['Success'] == true
    end

    # Void a previously submitted transaction that have not yet settled
    # @param [String] transaction ID
    # @return [Boolean]
    def void_transactions(id)
      resp = post('/transaction/void', 'TransactionId' => id)
      resp['Success'] == true
    end
  end
end