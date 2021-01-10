class ColdMeadow::MessageJob < ApplicationJob
  queue_as :default

  def perform(message_id)
    service = ColdMeadow::SmsApplicationService.new
    service.process_message(message_id: message_id)
  end
end
