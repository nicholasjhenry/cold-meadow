class ColdMeadow::SmsQueryService
  def find_by(params)
    ColdMeadow::Message.where(params).all
  end
end
