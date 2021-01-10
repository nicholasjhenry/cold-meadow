require "rails_helper"

RSpec.describe ColdMeadow::SmsApplicationService do
  describe "sending a message" do
    before { ActiveJob::Base.queue_adapter = :test }

    let(:message_params) do
      {
        uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
        recipients: [
          { phone_number: "+15141234567" },
          { phone_number: "+15141238950" }
        ],
        sender: { personal_name: "Jane Smith" },
        body: "Hello world!"
      }
    end

    it "handles valid params" do
      service = ColdMeadow::SmsApplicationService.new
      command = service.send_message(message_params)

      expect(command).to be_valid
      expect(ColdMeadow::Message.count).to eq(2)
      expect(ColdMeadow::MessageJob).to have_been_enqueued.exactly(2)
    end

    it "handles invalid params" do
      message_params = {}

      service = ColdMeadow::SmsApplicationService.new
      command = service.send_message(message_params)

      expect(command).to be_invalid
      expect(ColdMeadow::Message.count).to eq(0)
    end

    it "handles commands idempotently" do
      service = ColdMeadow::SmsApplicationService.new
      service.send_message(message_params)
      command = service.send_message(message_params)

      expect(command).to be_valid

      # Only two messages are inserted although the service was called twice
      expect(ColdMeadow::Message.count).to eq(2)

      # Jobs are still queues multiple times, but should be handled in the
      # Job logic itself; as you always should do, i.e. expect a job to be called
      # multiple times. Message.find_by(id: id, state: pending) resolves this issue
      expect(ColdMeadow::MessageJob).to have_been_enqueued.exactly(4)
    end
  end

  describe "processing a message" do
    it "handles a pending message" do
      message =
        ColdMeadow::Message.create!(
          uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
          recipient_phone_number: "+15141234567",
          sender_personal_name: "Jane Smith",
          body: "Hello world!",
          state: :pending
        )

      params = { message_id: message.id.to_s }

      service = ColdMeadow::SmsApplicationService.new
      command = service.process_message(params)

      original_updated_at = message.updated_at
      message.reload
      expect(message.state).to eq("sent")
      expect(message.updated_at).not_to eq(original_updated_at)
    end

    it "handles a sent message" do
      message =
        ColdMeadow::Message.create!(
          uuid: "bafb6c01-1171-4f75-b488-c538c5aacd5a",
          recipient_phone_number: "+15141234567",
          sender_personal_name: "Jane Smith",
          body: "Hello world!",
          state: :sent
        )

      params = { message_id: message.id.to_s }

      service = ColdMeadow::SmsApplicationService.new
      command = service.process_message(params)

      original_updated_at = message.updated_at
      message.reload
      expect(message.state).to eq("sent")
      expect(message.updated_at).to eq(original_updated_at)
    end
  end
end
