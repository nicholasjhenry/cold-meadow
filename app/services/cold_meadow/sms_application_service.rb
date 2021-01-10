require "securerandom"

class ColdMeadow::SmsApplicationService
  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)

    if command.valid?
      message_data = build_message_data(command)
      ids = insert_messages!(message_data)
      process_messages(ids)
    end

    command
  end

  private

  def build_message_data(command)
    now = Time.now.utc

    command.recipients.map do |recipient|
      {
        uuid: command.uuid,
        recipient_phone_number: recipient.phone_number,
        sender_personal_name: command.sender.personal_name,
        body: command.body,
        state: :pending,
        created_at: now,
        updated_at: now
      }
    end
  end

  def insert_messages!(data)
    result = ColdMeadow::Message.insert_all!(data)
    extract_ids(result)
  end

  def extract_ids(result)
    result.rows.map { |row| row.first }
  end

  def process_messages(ids)
    ids.each { |id| ColdMeadow::MessageJob.perform_later(id) }
  end
end
