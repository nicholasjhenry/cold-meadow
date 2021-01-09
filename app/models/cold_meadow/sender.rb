class ColdMeadow::Sender
  include ActiveModel::Model

  attr_accessor :personal_name
  validates :personal_name, presence: true
end
