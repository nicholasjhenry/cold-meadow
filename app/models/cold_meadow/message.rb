class ColdMeadow::Message < ApplicationRecord
  def self.table_name_prefix
    "cold_meadow_"
  end

  enum state: %i[pending processing sent failed]

  class << self
    def upsert_messages(attr)
      result = upsert_all(attr, unique_by: %i[uuid recipient_phone_number])
      extract_ids(result)
    end

    def flag_as_processing(id)
      number_rows_updated =
        self
          .where(state: :pending, id: id)
          .update_all(state: :processing, updated_at: Time.now.utc)

      number_rows_updated == 1
    end

    def find_processing!(id)
      find_by!(id: id, state: :processing)
    end

    private

    def extract_ids(result)
      result.to_a.map { |row| row.fetch("id") }
    end
  end

  def flag_as_sent
    update(state: :sent, sent_at: Time.now.utc)
  end
end
