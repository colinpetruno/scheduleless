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

ActiveRecord::Schema.define(version: 20170318143818) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_preferences", force: :cascade do |t|
    t.integer "company_id"
    t.integer "shift_overlap", default: 15, null: false
    t.index ["company_id"], name: "index_company_preferences_on_company_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "city"
    t.string   "county_province"
    t.integer  "postalcode"
    t.string   "country"
    t.string   "additional_details"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "company_id",         null: false
    t.index ["company_id"], name: "index_locations_on_company_id", using: :btree
  end

  create_table "preferred_hours", force: :cascade do |t|
    t.integer "user_id"
    t.integer "day"
    t.integer "start",   default: 0,    null: false
    t.integer "end",     default: 1440, null: false
    t.index ["user_id", "day"], name: "index_preferred_hours_on_user_id_and_day", unique: true, using: :btree
    t.index ["user_id"], name: "index_preferred_hours_on_user_id", using: :btree
  end

  create_table "user_locations", force: :cascade do |t|
    t.integer "user_id",                     null: false
    t.integer "location_id",                 null: false
    t.boolean "home",        default: false
    t.index ["location_id"], name: "index_user_locations_on_location_id", using: :btree
    t.index ["user_id", "location_id"], name: "index_user_locations_on_user_id_and_location_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_locations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "company_id"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "mobile_phone"
    t.string   "given_name"
    t.string   "family_name"
    t.string   "preferred_name"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
