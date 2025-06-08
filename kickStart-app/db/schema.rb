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

ActiveRecord::Schema[8.0].define(version: 2025_06_08_202121) do
  create_table "expirations", force: :cascade do |t|
    t.integer "service_id", null: false
    t.integer "recharge_percentage"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 1, null: false
    t.index ["service_id"], name: "index_expirations_on_service_id"
  end

  create_table "obras_sociales", force: :cascade do |t|
    t.integer "services_id"
    t.integer "users_id"
    t.integer "notifications_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notifications_id"], name: "index_obras_sociales_on_notifications_id"
    t.index ["services_id"], name: "index_obras_sociales_on_services_id"
    t.index ["users_id"], name: "index_obras_sociales_on_users_id"
  end

  create_table "services", force: :cascade do |t|
    t.integer "obras_sociales_id"
    t.integer "transactions_id"
    t.integer "amount_to_pay"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["obras_sociales_id"], name: "index_services_on_obras_sociales_id"
    t.index ["transactions_id"], name: "index_services_on_transactions_id"
  end

  add_foreign_key "expirations", "services"
  add_foreign_key "obras_sociales", "users", column: "users_id"
  add_foreign_key "services", "obras_sociales", column: "obras_sociales_id"
  add_foreign_key "services", "transactions", column: "transactions_id"
end
