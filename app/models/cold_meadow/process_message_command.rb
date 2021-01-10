class ColdMeadow::ProcessMessageCommand
  include ActiveModel::Model

  attr_accessor :message_id
  validates :message_id, presence: true
end
