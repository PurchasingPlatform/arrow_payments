describe ArrowPayments::PaymentMethod do
  it { is_expected.to respond_to :id }
  it { is_expected.to respond_to :card_type }
  it { is_expected.to respond_to :last_digits }
  it { is_expected.to respond_to :first_name }
  it { is_expected.to respond_to :last_name }
  it { is_expected.to respond_to :expiration_month }
  it { is_expected.to respond_to :expiration_year }
  it { is_expected.to respond_to :address }
  it { is_expected.to respond_to :address2 }
  it { is_expected.to respond_to :city }
  it { is_expected.to respond_to :state }
  it { is_expected.to respond_to :zip }
end
