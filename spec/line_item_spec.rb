describe ArrowPayments::LineItem do
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :commodity_code }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :price }
  it { is_expected.to respond_to :product_code }
  it { is_expected.to respond_to :unit_of_measure }

  describe "#to_source_hash" do
    let(:item) { described_class.new(json_fixture("line_item.json")) }

    it "returns a formatted hash" do
      expect(item.to_source_hash).to eq(json_fixture("line_item.json"))
    end
  end
end