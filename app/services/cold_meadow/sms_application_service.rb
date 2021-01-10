require "securerandom"

class ColdMeadow::SmsApplicationService
  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)

    if command.valid?
      message_data = build_message_data(command)
      result = insert_messages!(message_data)
      ids = extract_ids(result)
      process_messages_later(ids)
    end

    command
  end

  private

  def build_message_data(command)
    command.recipients.map do |recipient|
      {
        uuid: command.uuid,
        recipient_phone_number: recipient.phone_number,
        sender_personal_name: command.sender.personal_name,
        body: command.body,
        state: :pending
      }
    end
  end

  def insert_messages!(data)
    ColdMeadow::Message.upsert_all(
      data,
      unique_by: %i[uuid recipient_phone_number]
    )
  end

  def extract_ids(result)
    result.to_a.map { |key, id| id }
  end

  def process_messages_later(ids)
    ids.each { |id| ColdMeadow::MessageJob.perform_later(ids) }
  end
end
