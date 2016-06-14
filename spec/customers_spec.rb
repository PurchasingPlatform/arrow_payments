describe ArrowPayments::Customers do
  let(:client) { ArrowPayments.client }
  let(:customers) { client.customers }
  let(:customer) { client.customer(customer_id) }
  let(:customer_id) { 10162 }

  let(:request) { { headers: headers, body: body } }
  let(:headers) do
    {"Accept"=>"application/json", "Content-Type"=>"application/json", "User-Agent"=>"Ruby"}
  end

  before :all do
    ArrowPayments::Configuration.api_key = "foobar"
    ArrowPayments::Configuration.merchant_id = "foo"
    ArrowPayments::Configuration.mode = "sandbox"
    ArrowPayments::Configuration.debug = false
  end

  describe "#customers" do
    before do
      stub_request(:get, api_url("/foobar/customers")).
        to_return(status: 200, body: fixture("customers.json"))
    end

    it "returns an array of existing customers" do
      expect(customers).to be_an Array
      expect(customers.size).to eq 12
    end
  end

  describe "#customer" do
    it "returns an existing customer by ID" do
      stub_request(:get, api_url("/foobar/customer/#{customer_id}")).
        to_return(status: 200, body: fixture("customer.json"))

      expect(customer.id).to eq 10162
      expect(customer.name).to eq "First Supplies"
    end

    it "returns nil if customer does not exist" do
      stub_request(:get, api_url("/foobar/customer/12345")).
        to_return(status: 404, body: "", headers: {error: "Customer Not Found"})

      expect(client.customer(12345)).to be nil
    end
  end

  describe "#create_customer" do
    let(:new_customer) do
      ArrowPayments::Customer.new(
        name: "First Supplies",
        code: "First Supplies",
        contact: "John Peoples",
        email: "John.Peoples@arrow-test.com",
        phone: "8325539616"
      )
    end

    let(:body) do
      {
        "Name" => "First Supplies",
        "Code" => "First Supplies",
        "PrimaryContact" => "John Peoples",
        "PrimaryContactPhone" => "8325539616",
        "PrimaryContactEmailAddress" => "John.Peoples@arrow-test.com",
        "PaymentMethods" => [],
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    it "creates and returns a new customer" do
      stub_request(:post, api_url("/customer/add")).
        with(request).
        to_return(status: 200, body: fixture("customer.json"), headers: {}
      )

      expect(client.create_customer(new_customer).id).to eq 10162
    end

    it "raises error when unable to create" do
      msg = "Customer with Name First Supplies already exists for merchant"
      stub_request(:post, api_url("/customer/add")).
        with(request).to_return(status: 500, body: "", headers: { error: msg })

      expect {
        client.create_customer(new_customer)
      }.to raise_error ArrowPayments::Error, msg
    end
  end

  describe "#update_customer" do
    let(:body) do
      {
        "ID" => customer_id,
        "Name" => "Foobar",
        "Code" => "First Supplies",
        "PrimaryContact" => "John Peoples",
        "PrimaryContactPhone" => "8325539616",
        "PrimaryContactEmailAddress" => "John.Peoples@arrow-test.com",
        "RecurrentBilling" => [],
        "PaymentMethods" => [
          {
            "ID":12436,
            "CardType" => "Visa",
            "Last4" => "1111",
            "CardholderFirstName" => "Paola",
            "CardholderLastName" => "Chen",
            "ExpirationMonth" => 6,
            "ExpirationYear" => 2015,
            "BillingStreet1" => "7495 Center St.",
            "BillingCity" => "Chicago",
            "BillingState" => "IL",
            "BillingZip" => "60601"
          }
        ],
        "CustomerID" => customer_id,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    before do
      stub_request(:get, api_url("/foobar/customer/#{customer_id}")).
        to_return(status: 200, body: fixture("customer.json"))
      customer.name = "Foobar"
    end

    it "raises error if customer does not exist" do
      msg = "Customer Not Found"
      stub_request(:post, api_url("/customer/update")).
        with(request).to_return(status: 404, body: "", headers: { error: msg })

      expect {
        client.update_customer(customer)
      }.to raise_error ArrowPayments::NotFound, msg
    end

    it "raises error if customer is not valid" do
      msg = "Customer with Name Foobar already exists for merchant"
      stub_request(:post, api_url("/customer/update")).
        with(request).to_return(status: 500, body: "", headers: { error: msg })

      expect {
        client.update_customer(customer)
      }.to raise_error ArrowPayments::Error, msg
    end

    it "returns true if customer was updated" do
      stub_request(:post, api_url("/customer/update")).
        with(request).to_return(status: 200, body: {"Success" => true}.to_json)

      expect(client.update_customer(customer)).to be true
    end
  end

  describe "#delete_customer" do
    let(:msg) { "Customer Not Found" }
    let(:body) do
      {
        "CustomerID" => customer_id,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    it "raises error if customer does not exist" do
      stub_request(:post, api_url("/customer/delete")).
        with(request).to_return(status: 404, body: "", headers: { error: msg })

      expect {
        client.delete_customer(customer_id)
      }.to raise_error ArrowPayments::NotFound, msg
    end

    it "returns true if customer was deleted" do
      stub_request(:post, api_url("/customer/delete")).
        with(request).to_return(status: 200, body: { "Success" => true }.to_json)

      expect(client.delete_customer(customer_id)).to be true
    end
  end
end
