class ColdMeadow::SendMessageCommand
  include ActiveModel::Model

  attr_accessor :uuid, :to, :from, :body
  validates :uuid, :to, :from, :body, presence: true
end
