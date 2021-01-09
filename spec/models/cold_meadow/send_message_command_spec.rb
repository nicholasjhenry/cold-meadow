require "rails_helper"

RSpec.describe ColdMeadow::SendMessageCommand, type: :model do
  describe "validation" do
    context "given invalid params" do
      it "should be invalid" do
        expect(subject).to be_invalid
      end
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

      it "should be valid" do
        expect(subject).to be_valid
      end
    end
  end
end
