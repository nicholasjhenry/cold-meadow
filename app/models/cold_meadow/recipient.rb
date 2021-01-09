class ColdMeadow::Recipient
  include ActiveModel::Model

  # TODO: Consider more robust validation
  # https://www.twilio.com/docs/glossary/what-e164
  NAIVE_E164_FORMAT = /\A\+[1-9]\d{1,14}\z/

  attr_accessor :phone_number

  validates :phone_number,
            presence: true,
            format: { with: NAIVE_E164_FORMAT, message: "Only letters allowed" }
end
