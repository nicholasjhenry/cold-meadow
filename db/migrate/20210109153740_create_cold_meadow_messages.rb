class CreateColdMeadowMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :cold_meadow_messages do |t|
      t.binary :uuid, null: false
      t.string :to, null: false
      t.string :from, null: false
      t.string :body, null: false
      t.datetime :sent_at
      t.string :error_code
      t.string :error_message
      t.integer :state, null: false

      t.timestamps
    end
  end
end
