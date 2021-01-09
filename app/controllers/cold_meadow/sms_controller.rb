class ColdMeadow::SmsController < ApplicationController
  def create
    # TODO: implement strong params
    message_params = params.fetch(:message)

    if ColdMeadow::SmsApplicationService.send_message(message_params)
      render json: { status: :accepted }, status: :accepted
    else
      # TODO: handle error path
    end
  end
end
