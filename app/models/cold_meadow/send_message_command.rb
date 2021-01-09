class ColdMeadow::SendMessageCommand
  include ActiveModel::Model

  attr_accessor :uuid, :recipients, :sender, :body
  validates :uuid, :recipients, :sender, :body, presence: true
end
