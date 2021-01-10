# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_09_153740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cold_meadow_messages", force: :cascade do |t|
    t.binary "uuid", null: false
    t.string "recipient_phone_number", null: false
    t.string "sender_personal_name", null: false
    t.string "body", null: false
    t.datetime "sent_at"
    t.string "error_code"
    t.string "error_message"
    t.integer "state", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["uuid", "recipient_phone_number"], name: "index_cold_meadow_messages_on_uuid_and_recipient_phone_number", unique: true
  end

end
