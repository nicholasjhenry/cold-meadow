class ColdMeadow::SmsController < ApplicationController
  def create
    service = ColdMeadow::SmsApplicationService.new
    command = service.send_message(message_params)

    if command.valid?
      render json: { status: :accepted }, status: :accepted
    else
      render json: { data: command, status: :error },
             status: :unprocessable_entity
    end
  end

  def index
    uuid = params.fetch(:uuid)
    service = ColdMeadow::SmsQueryService.new
    messages = service.find_by(uuid: uuid)

    render json: { data: messages }, status: :ok
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
