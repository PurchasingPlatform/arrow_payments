describe ArrowPayments::PaymentMethods do
  let(:client) { ArrowPayments.client }
  let(:url) { "https://secure.nmi.com/api/v2/three-step/#{token}" }
  let(:token) { "4i873m0s" }

  let(:card) do
    {
      first_name: "John",
      last_name: "Doe",
      number: "4111111111111111",
      security_code: "123",
      expiration_month: 12,
      expiration_year: 14
    }
  end

  let(:address) do
    {
      address: "3128 N Broadway",
      address2: "Upstairs",
      city: "Chicago",
      state: "IL",
      zip: "60657",
      phone: "123123123"
    }
  end

  let(:request) do
    {
      headers: headers,
      body: body
    }
  end

  let(:headers) do
    {"Accept"=>"application/json", "Content-Type"=>"application/json", "User-Agent"=>"Ruby"}
  end

  let(:body) do
    {
      "CustomerId" => 11843,
      "BillingAddress" => billing_address,
      "ApiKey" => "foobar",
      "MID" => "foo"
    }
  end

  let(:arrow_request) do
    {
      headers: request_headers,
      body: request_body
    }
  end

  let(:request_body) do
    {
      "billing-cc-exp"     => "1214",
      "billing-cc-number"  => "4111111111111111",
      "billing-cvv"        => "123",
      "billing-first-name" => "John",
      "billing-last-name"  => "Doe"
    }
  end

  let(:request_headers) do
    {
      "Accept"       => "*/*",
      "Content-Type" => "application/x-www-form-urlencoded"
    }
  end

  let(:billing_address) { {} }


  before :all do
    ArrowPayments::Configuration.api_key = "foobar"
    ArrowPayments::Configuration.merchant_id = "foo"
    ArrowPayments::Configuration.mode = "sandbox"
    ArrowPayments::Configuration.debug = false
  end

  describe "#start_payment_method" do
    context "when the request is accepted" do
      let(:billing_address) do
        {
          "Address1" => "3128 N Broadway",
          "Address2" => "Upstairs",
          "City" => "Chicago",
          "State" => "IL",
          "Postal" => "60657",
          "Phone" => "123123123"
        }
      end

      it "returns submit form url" do
        stub_request(:post, api_url("/paymentmethod/start")).
          with(request).
          to_return(status: 200, body: fixture("start_payment_method.json"), headers: {})

        expected_url = client.start_payment_method(11843, address)
        expect(expected_url).to eq url
      end
    end

    context "when the request is rejected" do
      it "raises error if customer does not exist" do
        stub_request(:post, api_url("/paymentmethod/start")).
          with(request).
          to_return(status: 404, body: "", headers: {error: "Invalid customer"})

        expect {
          client.start_payment_method(11843, {})
        }.to raise_error ArrowPayments::NotFound, "Invalid customer"
      end

      it "raises error if address is not valid" do
        stub_request(:post, api_url("/paymentmethod/start")).
          with(request).
          to_return(status: 500, body: "", headers: {error: "Something went wrong"})

        expect {
          client.start_payment_method(11843, {})
        }.to raise_error ArrowPayments::Error
      end
    end
  end

  describe "#setup_payment_method" do
    before do
      stub_request(:post, url).with(arrow_request).
        to_return(status: 200, body: "", headers: {location: "http://arrowdemo.cloudapp.net/api/echo?token-id=4i873m0s"} )
    end

    it "returns a token to complete payment" do
      expect(client.setup_payment_method(url, card)).to eq("4i873m0s")
    end
  end

  describe "#complete_payment_method" do
    let(:body) do
      {
        "TokenID" => token,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    before do
      stub_request(:post, api_url("/paymentmethod/complete")).
        with(request).
        to_return(status: 200, body: fixture("complete_payment_method.json"), headers: {})
    end

    it "returns a newly created payment method" do
      credit_card = client.complete_payment_method(token)
      expect(credit_card).to be_a ArrowPayments::PaymentMethod
      expect(credit_card.id).to eq(14240)
    end
  end

  describe "#create_payment_method" do
    let(:completed_body) do
      {
        "TokenID" => token,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end

    let(:billing_address) do
      {
        "Address1" => "3128 N Broadway",
        "Address2" => "Upstairs",
        "City" => "Chicago",
        "State" => "IL",
        "Postal" => "60657",
        "Phone" => "123123123"
      }
    end

    it "return a newly created payment method" do
      stub_request(:post, api_url("/paymentmethod/start")).
        with(request).
        to_return(status: 200, body: fixture("start_payment_method.json"), headers: {})

      stub_request(:post, url).with(arrow_request).
        to_return(status: 200, body: "", headers: {location: "http://arrowdemo.cloudapp.net/api/echo?token-id=4i873m0s"})

      stub_request(:post, api_url("/paymentmethod/complete")).
        with(body: completed_body, headers: headers).
        to_return(status: 200, body: fixture("complete_payment_method.json"), headers: {})

      credit_card = client.create_payment_method(11843, address, card)
      expect(credit_card.id).to eq(14240)
    end
  end

  describe "#destroy_payment_method" do
    let(:body) do
      {
        "PaymentMethodId" => 12345,
        "ApiKey" => "foobar",
        "MID" => "foo"
      }
    end
    it "raises error if payment method does not exist" do
      stub_request(:post, api_url("/paymentmethod/delete")).
        with(request).
        to_return(status: 404, body: "", headers: {error: "Payment Method Not Found"})

      expect {
        client.delete_payment_method(12345)
      }.to raise_error ArrowPayments::NotFound, "Payment Method Not Found"
    end

    it "returns true if payment methods was deleted" do
      stub_request(:post, api_url("/paymentmethod/delete")).
      with(request).
      to_return(status: 200, body: {"Success" => true}.to_json, headers: {})

      expect(client.delete_payment_method(12345)).to be true
    end
  end
end
