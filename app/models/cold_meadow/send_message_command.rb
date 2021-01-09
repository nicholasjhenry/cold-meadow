class ColdMeadow::SendMessageCommand
  include ActiveModel::Model

  attr_accessor :uuid, :recipients, :sender, :body
  validates :uuid, :recipients, :sender, :body, presence: true

  def recipients=(params)
    @recipients ||= []
    params.each do |recipient_params|
      recipient = ColdMeadow::Recipient.new(recipient_params)
      @recipients.push(recipient)
    end
  end

  def sender=(sender_params)
    @sender = ColdMeadow::Sender.new(sender_params)
  end
end
