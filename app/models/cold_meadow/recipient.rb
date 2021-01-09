class ColdMeadow::Recipient
  include ActiveModel::Model

  attr_accessor :phone_number
  validates :phone_number, presence: true
end
