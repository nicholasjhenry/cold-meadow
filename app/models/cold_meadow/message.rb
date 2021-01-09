class ColdMeadow::Message < ApplicationRecord
  def self.table_name_prefix
    "cold_meadow_"
  end

  enum state: %i[pending sent failed]
end
