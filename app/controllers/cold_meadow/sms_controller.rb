class ColdMeadow::SmsController < ApplicationController
  def create
    if ColdMeadow::SmsApplicationService.send_message(message_params)
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
