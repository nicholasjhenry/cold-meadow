require "securerandom"

class ColdMeadow::SmsApplicationService
  def self.send_message(params)
    new.send_message(params)
  end

  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)
    command.recipients.map { |recipient| create_message(recipient, command) }

    true
  end

  private

  def create_message(recipient, command)
    ColdMeadow::Message.create!(
      uuid: command.uuid,
      recipient_phone_number: recipient.phone_number,
      sender_personal_name: command.sender.personal_name,
      body: command.body,
      state: :pending
    )
  end
end
