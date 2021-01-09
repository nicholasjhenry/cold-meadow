require "rails_helper"

RSpec.describe ColdMeadow::SmsApplicationService do
  describe "sending a message" do
    it "handles valid params" do
      message_params = {
        uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
        recipients: [
          { phone_number: "+15141234567" },
          { phone_number: "+15141238950" }
        ],
        sender: { personal_name: "Jane Smith" },
        body: "Hello world!"
      }

      service = ColdMeadow::SmsApplicationService.new
      command = service.send_message(message_params)

      expect(command)
      expect(ColdMeadow::Message.count).to eq(2)
    end

    it "handles invalid params" do
      message_params = {}

      service = ColdMeadow::SmsApplicationService.new
      command = service.send_message(message_params)

      expect(command).to be_invalid
      expect(ColdMeadow::Message.count).to eq(0)
    end
  end
end
