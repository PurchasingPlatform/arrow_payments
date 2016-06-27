describe ArrowPayments do
  let(:client) do
    ArrowPayments.client(api_key: "foo", mode: "production", merchant_id: 12345, debug: false)
  end

  it "returns client instance for options" do
    expect(client.kind_of?(ArrowPayments::Client)).to be true
    expect(client.api_key).to eq("foo")
    expect(client.mode).to eq("production")
    expect(client.merchant_id).to eq(12345)
    expect(client.debug).to eq(false)
  end

  context "when preconfigured" do
    before do
      ArrowPayments::Configuration.api_key = "bar"
      ArrowPayments::Configuration.mode = "sandbox"
      ArrowPayments::Configuration.merchant_id = 12345
    end

    after do
      ArrowPayments::Configuration.api_key = nil
      ArrowPayments::Configuration.mode = nil
      ArrowPayments::Configuration.merchant_id = nil
    end

    it "returns preconfigured client instance" do
      p_client = ArrowPayments.client
      expect(p_client.api_key).to eq("bar")
      expect(p_client.mode).to eq("sandbox")
      expect(p_client.merchant_id).to eq(12345)
    end
  end
end
