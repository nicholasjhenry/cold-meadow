require "rails_helper"

RSpec.describe "ColdMeadow::SmsApplicationService" do
  it "sends a message" do
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
    service.send_message(message_params)

    expect(ColdMeadow::Message.count).to eq(2)
  end
end
