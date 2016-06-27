describe ArrowPayments::Transactions do
  let(:client) { ArrowPayments.client }
  let(:headers) { {"Accept"=>"application/json", "Content-Type"=>"application/json", "User-Agent"=>"Ruby"} }
  let(:request) do
    {
      body: body,
      headers: headers
    }
  end


  before :all do
    ArrowPayments::Configuration.api_key = "foobar"
    ArrowPayments::Configuration.merchant_id = "foo"
    ArrowPayments::Configuration.mode = "sandbox"
  end

  describe "#transaction" do
    it "returns a transaction by ID" do
      stub_api(:get, "/foobar/transaction/40023", body: fixture("transaction.json"))

      expect(client.transaction("40023").id).to eq(40023)
    end

    it "returns nil if transaction does not exist" do
      stub_request(:get, api_url("/foobar/transaction/400231")).
        to_return(status: 404, body: "", headers: {error: "Transaction Not Found"})

      expect(client.transaction("400231")).to be nil
    end
  end

  describe "#transactions" do
    it "raises error on invalid status argument" do
      expect {
        client.transactions(10162, "Foo")
      }.to raise_error "Invalid status: Foo"
    end

    it "returns unsettled transactions" do
      stub_request(:get, api_url("/foobar/customer/10162/Transactions/NotSettled")).
        to_return(status: 200, body: fixture("transactions.json"), headers: {})

      transactions = client.transactions(10162, "NotSettled")

      expect(transactions.size).to eq(2)
      expect(transactions.map(&:status).uniq.first).to eq("Not Settled")
    end
  end

  describe "#create_transaction" do
    let(:payment_information) do
      {
        customer_id: "10162",
        payment_method_id: "0",
        transaction_type: "sale",
        total_amount: 250,
        tax_amount: 0,
        shipping_amount: 0
      }
    end

    let(:body) do
      {
        "TransactionType" => "sale",
        "TotalAmount" => 250,
        "TransactionSource" => "API",
        "PaymentMethodID" => "0",
        "TaxAmount" => 0,
        "ShippingAmount" => 0,
        "CustomerID" => "10162",
        "Amount" => 250,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    it "creates a new transaction record" do
      stub_request(:post, api_url("/transaction/add")).with(request).
        to_return(status: 200, body: fixture("transaction.json"), headers: {})

      transaction = client.create_transaction(payment_information)
      expect(transaction).to_not be nil
      expect(transaction.customer_name).to eq("First Supplies")
      expect(transaction.authorization_code).to eq("123456")
      expect(transaction.status).to eq("Not Settled")
    end

    it "raises an error if the payment method is not found" do
      stub_request(:post, api_url("/transaction/add")).with(request).
        to_return(status: 404, body: "", headers: {error: "Payment Method Not Found"})

      expect {
        client.create_transaction(payment_information)
      }.to raise_error "Payment Method Not Found"
    end
  end

  describe "#capture_transaction" do
    let(:body) do
      {
        "TransactionId" => 10162,
        "Amount" => 100,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    it "raises error if transaction does not exist" do
      stub_request(:post, api_url("/transaction/capture")).with(request).
        to_return(status: 404, body: "", headers: {error: "Transaction Not Found"})

      expect {
        client.capture_transaction(10162, 100)
      }.to raise_error "Transaction Not Found"
    end

    it "captures transaction for amount" do
      stub_request(:post, api_url("/transaction/capture")).with(request).
        to_return(status: 200, body: fixture("transaction_capture.json"), headers: {})

      expect(client.capture_transaction(10162, 100)).to be true
    end

    it "raises a error if amount is greater than original" do
      msg = "Unable to Capture for more than the original amount of $10.00"
      stub_request(:post, api_url("/transaction/capture")).with(request).
        to_return(status: 400, body: "", headers: {error: msg})

      expect {
        client.capture_transaction(10162, 100)
      }.to raise_error msg
    end

    it "raises an error if transaction is already captured" do
      stub_request(:post, api_url("/transaction/capture")).with(request).
        to_return(status: 400, body: "", headers: {error: "Transaction is Captured Already"})

      expect {
        client.capture_transaction(10162, 100)
      }.to raise_error "Transaction is Captured Already"
    end
  end

  describe "#void_transaction" do
    let(:body) do
      {
        "TransactionId" => 10162,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    context "successful request" do
      it "voids transaction" do
        stub_request(:post, api_url("/transaction/void")).with(request).
          to_return(status: 200, body: fixture("void_transaction.json"), headers: {})

        expect(client.void_transaction(10162)).to be true
      end
    end

    context "unsuccessful requests" do
      it "raises an error if transaction does not exist" do
        stub_request(:post, api_url("/transaction/void")).with(request).
          to_return(status: 404, body: "", headers: {error: "Transaction Not Found"})

        expect {
          client.void_transaction(10162)
        }.to raise_error "Transaction Not Found"
      end

      it "raises an error if transaction is already voided" do
        stub_request(:post, api_url("/transaction/void")).with(request)
          .to_return(status: 400, body: "", headers: {error: "Transaction Already Void"})

        expect {
          client.void_transaction(10162)
        }.to raise_error "Transaction Already Void"
      end
    end
  end
end
