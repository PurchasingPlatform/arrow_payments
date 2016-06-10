describe ArrowPayments::Configuration do
  it "sets credentials" do
    described_class.api_key = "foobar"
    described_class.mode = "production"
    described_class.merchant_id = 12345
    described_class.debug = true

    expect(described_class.api_key).to eq("foobar")
    expect(described_class.mode).to eq("production")
    expect(described_class.merchant_id).to eq(12345)
    expect(described_class.debug).to eq(true)
  end
end