class ColdMeadow::SmsController < ApplicationController
  def create
    service = ColdMeadow::SmsApplicationService.new
    command = service.send_message(message_params)

    if command.valid?
      render json: { status: :accepted }, status: :accepted
    else
      # TODO: handle error path
    end
  end

  private

  def message_params
    params
      .require(:message)
      .permit(
        :uuid,
        :body,
        sender: [:personal_name],
        recipients: [:phone_number]
      )
  end
end
