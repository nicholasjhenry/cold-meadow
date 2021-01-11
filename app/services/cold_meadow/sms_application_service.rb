class ColdMeadow::SmsApplicationService
  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)
    return command unless command.valid?

    message_attrs = build_message_attrs(command)
    message_ids = record_messages(message_attrs)
    process_messages_later(message_ids)

    command
  end

  def process_message(params)
    command = ColdMeadow::ProcessMessageCommand.new(params)
    return command unless command.valid?

    try_process_message(command)

    command
  end

  private

  def build_message_attrs(command)
    command.to_message_attrs
  end

  def record_messages(attrs)
    ColdMeadow::Message.upsert_messages(attrs)
  end

  def process_messages_later(message_ids)
    message_ids.each do |message_id|
      ColdMeadow::MessageJob.perform_later(message_id)
    end
  end

  def try_process_message(command)
    # Perform an atomic update to prevent race conditions and avoid performing
    # a database transaction while accessing an external API
    ColdMeadow::Message.process(command.message_id) do |message|
      # TODO: error handling
      # TODO: Call Twilio
      # https://www.twilio.com/docs/sms/quickstart/ruby
    end
  end
end
