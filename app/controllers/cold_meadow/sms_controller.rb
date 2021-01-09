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
      .permit(:uuid, :body, from: [:personal_name], to: [:phone_number])
  end
end
