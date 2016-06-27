describe ArrowPayments::Customer do
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :code }
  it { is_expected.to respond_to :contact }
  it { is_expected.to respond_to :phone }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :recurring_billings }
  it { is_expected.to respond_to :payment_methods }

  describe "#new" do
    let(:customer_data) { json_fixture("customer.json") }
    let(:customer) { described_class.new(customer_data) }

    it "properly assigns attributes" do
      expect(customer.id).to eq(10162)
      expect(customer.name).to eq("First Supplies")
      expect(customer.code).to eq("First Supplies")
      expect(customer.contact).to eq("John Peoples")
      expect(customer.phone).to eq("8325539616")
      expect(customer.email).to eq("John.Peoples@arrow-test.com")
      expect(customer.recurring_billings).to be_empty
      expect(customer.payment_methods).to_not be_empty
    end
  end
end