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

ActiveRecord::Schema.define(version: 2019_10_14_213929) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.string "name", null: false
    t.string "room", null: false
    t.integer "capacity", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "registrations_count", default: 0
    t.index ["date", "name", "room"], name: "index_activities_on_date_and_name_and_room", unique: true
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "creator_id", null: false
    t.bigint "student_id", null: false
    t.bigint "teacher_id", null: false
    t.bigint "activity_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attendance", default: 0, null: false
    t.index ["activity_id", "student_id"], name: "index_registrations_on_activity_id_and_student_id", unique: true
    t.index ["activity_id"], name: "index_registrations_on_activity_id"
    t.index ["creator_id"], name: "index_registrations_on_creator_id"
    t.index ["student_id"], name: "index_registrations_on_student_id"
    t.index ["teacher_id"], name: "index_registrations_on_teacher_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["name", "title"], name: "index_teachers_on_name_and_title", unique: true
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
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "image_url"
    t.integer "role", default: 0, null: false
    t.bigint "teacher_id"
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["teacher_id"], name: "index_users_on_teacher_id"
  end

  add_foreign_key "registrations", "activities"
  add_foreign_key "registrations", "teachers"
  add_foreign_key "registrations", "users", column: "creator_id"
  add_foreign_key "registrations", "users", column: "student_id"
  add_foreign_key "users", "teachers"
end
