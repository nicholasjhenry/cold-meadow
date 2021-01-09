require "securerandom"

class ColdMeadow::SmsApplicationService
  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)

    if command.valid?
      command.recipients.map do |recipient|
        message = create_message(recipient, command)
        ColdMeadow::MessageJob.perform_later(message)
      end
    end

    command
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
