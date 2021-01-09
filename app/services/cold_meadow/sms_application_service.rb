require "securerandom"

class ColdMeadow::SmsApplicationService
  def self.send_message(params)
    new.send_message(params)
  end

  def send_message(params)
    params.fetch(:to).map { |recipient| create_message(recipient, params) }
    true
  end

  private

  def create_message(recipient, params)
    ColdMeadow::Message.create!(
      uuid: params[:uuid],
      to: recipient[:phone_number],
      from: params[:from][:personal_name],
      body: params[:body],
      state: :pending
    )
  end
end
