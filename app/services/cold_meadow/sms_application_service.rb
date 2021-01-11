class ColdMeadow::SmsApplicationService
  def send_message(params)
    command = ColdMeadow::SendMessageCommand.new(params)
    return command unless command.valid?

    message_attrs = build_message_attrs(command)
    ids = record_messages(message_attrs)
    process_messages_later(ids)

    command
  end

  def process_message(params)
    command = ColdMeadow::ProcessMessageCommand.new(params)
    return command unless command.valid?

    message = flag_message_as_processing(command)
    return command unless message.present?

    try_process_message(message)

    # TODO: error handling
    flag_message_as_sent(message)

    command
  end

  private

  def build_message_attrs(command)
    command.to_message_attrs
  end

  def record_messages(attrs)
    ColdMeadow::Message.upsert_messages(attrs)
  end

  def process_messages_later(ids)
    ids.each { |id| ColdMeadow::MessageJob.perform_later(id) }
  end

  # Perform an atomic update to prevent race conditions and avoid performing
  # a database transaction while accessing an external API
  def flag_message_as_processing(command)
    ColdMeadow::Message.find_and_flag_as_processing(command.message_id)
  end

  def flag_message_as_sent(message)
    message.flag_as_sent
  end

  def try_process_message(command)
    # TODO: Call Twilio
    # https://www.twilio.com/docs/sms/quickstart/ruby
  end
end
