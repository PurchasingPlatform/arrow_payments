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

    alias :get_transaction :transaction

    # Get customer transactions by status
    # @param [String] customer ID
    # @param [String] transaction status
    # @return [Array<Transaction>]
    def transactions(customer_id, status="NotSettled")
      unless Transaction::STATUSES.include?(status)
        raise ArgumentError, "Invalid status: #{status}"
      end

      resp = get("/customer/#{customer_id}/Transactions/#{status}")
      resp["Transactions"].map { |t| Transaction.new(t) }
    end

    alias :get_transactions :transactions

    # Create a new transaction
    # @return [Transaction]
    def create_transaction(transaction)
      if transaction.kind_of?(Hash)
        transaction = ArrowPayments::Transaction.new(transaction)
      end

      # Set default transaction attributes
      transaction.transaction_source = "API"

      params = transaction.to_source_hash
      params["Amount"] = params["TotalAmount"]

      resp = post("/transaction/add", params)

      if resp["Success"] == true
        ArrowPayments::Transaction.new(resp)
      else
        raise ArrowPayments::Error, resp["Message"]
      end
    end

    # Capture an unsettled transaction
    # @param [String] transaction ID
    # @param [Integer] amount, less than or equal to original amount
    # @return [Boolean]
    def capture_transaction(id, amount)
      resp = post("/transaction/capture", "TransactionId" => id, "Amount" => amount)
      resp["Success"] == true
    end

    # Void a previously submitted transaction that have not yet settled
    # @param [String] transaction ID
    # @return [Boolean]
    def void_transaction(id)
      resp = post("/transaction/void", "TransactionId" => id)
      resp["Success"] == true
    end
  end
end
