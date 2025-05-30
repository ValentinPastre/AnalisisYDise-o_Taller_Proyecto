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

ActiveRecord::Schema[8.0].define(version: 2025_05_29_224624) do
  create_table "accounts", force: :cascade do |t|
    t.integer "user_id"
    t.integer "balance", default: 0
    t.string "password_digest"
    t.string "cvu"
    t.string "alias"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "security_questions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "account_id", null: false
    t.string "question"
    t.string "answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_security_questions_on_account_id"
    t.index ["user_id"], name: "index_security_questions_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.integer "source_account_id"
    t.integer "target_account_id"
    t.integer "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_account_id"], name: "index_transactions_on_source_account_id"
    t.index ["target_account_id"], name: "index_transactions_on_target_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "dni"
    t.string "lastname"
    t.string "cuil"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "password_digest"
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "security_questions", "accounts"
  add_foreign_key "security_questions", "users"
  add_foreign_key "transactions", "accounts", column: "source_account_id"
  add_foreign_key "transactions", "accounts", column: "target_account_id"
end
