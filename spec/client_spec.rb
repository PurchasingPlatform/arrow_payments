describe ArrowPayments::Client do
  describe "#initialize" do
    it "requires an api key" do
      expect { described_class.new }.to raise_error "API key required"
    end

    it "requires a merchant id" do
      expect {
        described_class.new(api_key: "foobar")
      }.to raise_error "Merchant ID required"
    end

    it "validates api mode" do
      expect {
        described_class.new(api_key: "foobar", merchant_id: "foobar", mode: "foobar")
      }.to raise_error "Invalid mode: foobar"
    end

    it "sets production mode by default" do
      client = described_class.new(api_key: "foobar", merchant_id: "foobar")
      expect(client.mode).to eq("production")
    end
  end

  describe "#sandbox?" do
    it "returns true if sandbox mode" do
      client = described_class.new(api_key: "foobar", merchant_id: "foobar", mode: "sandbox")

      expect(client.sandbox?).to be true
      expect(client.production?).to_not be true
    end
  end

  describe "#production?" do
    it "returns true if production mode" do
      client = described_class.new(api_key: "foobar", merchant_id: "foobar", mode: "production")

      expect(client.sandbox?).to be false
      expect(client.production?).to be true
    end
  end
end
