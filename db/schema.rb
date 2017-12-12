# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171207013122) do

  create_table "attends", force: :cascade do |t|
    t.integer "rocket_member_id"
    t.integer "rocket_id"
    t.date "date"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rocket_id"], name: "index_attends_on_rocket_id"
    t.index ["rocket_member_id"], name: "index_attends_on_rocket_member_id"
  end

  create_table "befores", force: :cascade do |t|
    t.string "email"
    t.integer "member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_befores_on_member_id"
  end

  create_table "counts", force: :cascade do |t|
    t.integer "count"
    t.integer "product_id"
    t.date "date"
    t.integer "buffer", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "goods", default: false
    t.string "description"
    t.index ["product_id"], name: "index_counts_on_product_id"
  end

  create_table "homes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "members", force: :cascade do |t|
    t.string "email"
    t.string "before"
    t.string "name"
    t.integer "rocket"
    t.string "phone"
    t.integer "follower"
    t.string "comment"
    t.date "date"
    t.date "permit"
    t.boolean "active"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mission_checks", force: :cascade do |t|
    t.integer "mission_id"
    t.integer "rocket_member_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mission_id"], name: "index_mission_checks_on_mission_id"
    t.index ["rocket_member_id"], name: "index_mission_checks_on_rocket_member_id"
  end

  create_table "missions", force: :cascade do |t|
    t.string "content"
    t.date "date"
    t.integer "rocket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rocket_id"], name: "index_missions_on_rocket_id"
  end

  create_table "pics", force: :cascade do |t|
    t.string "img"
    t.integer "regram_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["regram_id"], name: "index_pics_on_regram_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "kind"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "date", default: "2017-05-22"
    t.boolean "empty", default: false
  end

  create_table "regrams", force: :cascade do |t|
    t.date "date"
    t.text "content"
    t.string "img"
    t.string "url"
    t.integer "member_id"
    t.integer "product_id"
    t.integer "timepool_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_regrams_on_member_id"
    t.index ["product_id"], name: "index_regrams_on_product_id"
    t.index ["timepool_id"], name: "index_regrams_on_timepool_id"
  end

  create_table "rocket_members", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "identity"
    t.integer "follower"
    t.integer "group"
    t.string "homepage"
    t.integer "product_id"
    t.integer "rocket_id"
    t.text "application"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_rocket_members_on_product_id"
    t.index ["rocket_id"], name: "index_rocket_members_on_rocket_id"
  end

  create_table "rocket_pics", force: :cascade do |t|
    t.string "img"
    t.integer "rocket_regram_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rocket_regram_id"], name: "index_rocket_pics_on_rocket_regram_id"
  end

  create_table "rocket_regrams", force: :cascade do |t|
    t.date "date"
    t.text "content"
    t.string "img"
    t.string "url"
    t.integer "regram_at"
    t.integer "rocket_id"
    t.integer "rocket_member_id"
    t.integer "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_rocket_regrams_on_product_id"
    t.index ["rocket_id"], name: "index_rocket_regrams_on_rocket_id"
    t.index ["rocket_member_id"], name: "index_rocket_regrams_on_rocket_member_id"
  end

  create_table "rockets", force: :cascade do |t|
    t.integer "unit"
    t.integer "term"
    t.date "start_date"
    t.date "end_date"
    t.integer "volume"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mission", default: 0
  end

  create_table "tags", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.integer "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "timepools", force: :cascade do |t|
    t.string "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
