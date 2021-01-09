require "rails_helper"

RSpec.describe ColdMeadow::Recipient, type: :model do
  context "given a valid phone number" do
    subject { ColdMeadow::Recipient.new(phone_number: "+151412345678") }
    it { is_expected.to be_valid }
  end

  context "given an invalid phone number" do
    subject { ColdMeadow::Recipient.new(phone_number: "123") }
    it { is_expected.to be_invalid }
  end
end
