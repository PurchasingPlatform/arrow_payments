describe ArrowPayments::RecurringBilling do
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :payment_method_id }
  it { is_expected.to respond_to :frequency }
  it { is_expected.to respond_to :total_amount }
  it { is_expected.to respond_to :shipping_amount }
  it { is_expected.to respond_to :description }
  it { is_expected.to respond_to :transaction_day }
  it { is_expected.to respond_to :date_created }
  it { is_expected.to respond_to :frequency_name }

  describe "#frequency_name" do
    let(:billing) { described_class.new }

    it "returns nil is frequency is not set" do
      expect(billing.frequency_name).to be nil
    end

    it "returns a human name for frequency" do
      %w(W M Q Y).each do |s|
        billing.frequency = s
        expect(billing.frequency_name).to_not be nil
      end
    end
  end
end