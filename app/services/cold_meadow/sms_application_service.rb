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

  def process_message(params)
    command = ColdMeadow::ProcessMessageCommand.new(params)
    return command unless command.valid?

    message = mark_message_as_processing(command)
    return command unless message.present?

    try_process_message(message)

    # TODO: error handling
    mark_message_as_sent(message)

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
    result.to_a.map { |row| row.fetch("id") }
  end

  def process_messages_later(ids)
    ids.each { |id| ColdMeadow::MessageJob.perform_later(id) }
  end

  # Perform an atomic update to prevent race conditions and avoid performing
  # a database transaction while accessing an external API
  def mark_message_as_processing(command)
    number_rows_updated =
      ColdMeadow::Message
        .where(state: :pending, id: command.message_id)
        .update_all(state: :processing, updated_at: Time.now.utc)

    if number_rows_updated == 1
      ColdMeadow::Message.find_by!(id: command.message_id, state: :processing)
    end
  end

  def mark_message_as_sent(message)
    message.update(state: :sent, sent_at: Time.now.utc)
  end

  def try_process_message(command)
    # TODO: Call Twilio
    # https://www.twilio.com/docs/sms/quickstart/ruby
  end
end
