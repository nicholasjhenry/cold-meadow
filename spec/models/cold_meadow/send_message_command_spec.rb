require "rails_helper"

RSpec.describe ColdMeadow::SendMessageCommand, type: :model do
  describe "validation" do
    context "given no params" do
      it { is_expected.to be_invalid }
    end

    context "given an invalid root param" do
      subject do
        ColdMeadow::SendMessageCommand.new(
          uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
          recipients: [
            { phone_number: "+15141234567" },
            { phone_number: "+15141238950" }
          ],
          sender: { personal_name: "Jane Smith" },
          body: nil
        )
      end

      it { is_expected.to be_invalid }
    end

    context "given an invalid leaf param" do
      subject do
        ColdMeadow::SendMessageCommand.new(
          uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
          recipients: [
            { phone_number: "+15141234567" },
            { phone_number: "+15141238950" }
          ],
          sender: { personal_name: nil },
          body: nil
        )
      end

      it { is_expected.to be_invalid }
    end

    context "given valid params" do
      subject do
        ColdMeadow::SendMessageCommand.new(
          uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
          recipients: [
            { phone_number: "+15141234567" },
            { phone_number: "+15141238950" }
          ],
          sender: { personal_name: "Jane Smith" },
          body: "Hello world!"
        )
      end

      it { is_expected.to be_valid }
    end
  end
end
