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

ActiveRecord::Schema.define(version: 20170710140540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blog_posts", force: :cascade do |t|
    t.string   "title",                               null: false
    t.string   "slug",                                null: false
    t.string   "preview_description"
    t.text     "body",                                null: false
    t.integer  "category",            default: 0,     null: false
    t.integer  "created_by_id",                       null: false
    t.boolean  "published",           default: false, null: false
    t.datetime "published_at"
    t.integer  "view_count",          default: 0,     null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["slug"], name: "index_blog_posts_on_slug", using: :btree
  end

  create_table "check_ins", force: :cascade do |t|
    t.integer  "shift_id"
    t.bigint   "check_in_date_time"
    t.bigint   "check_out_date_time"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["shift_id"], name: "index_check_ins_on_shift_id", using: :btree
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                               null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "stripe_customer_id"
    t.boolean  "demo",               default: false, null: false
    t.string   "hash_key"
  end

  create_table "credit_cards", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "exp_month",                      null: false
    t.integer  "exp_year",                       null: false
    t.integer  "last_4",                         null: false
    t.string   "brand",                          null: false
    t.string   "token",                          null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "default",        default: false, null: false
    t.string   "stripe_card_id"
    t.index ["company_id"], name: "index_credit_cards_on_company_id", using: :btree
  end

  create_table "email_captures", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "employee_positions", force: :cascade do |t|
    t.integer "user_id"
    t.integer "position_id"
    t.boolean "primary",     default: false, null: false
    t.index ["position_id"], name: "index_employee_positions_on_position_id", using: :btree
    t.index ["user_id"], name: "index_employee_positions_on_user_id", using: :btree
  end

  create_table "firebase_tokens", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "token",                     null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["user_id", "token"], name: "index_firebase_tokens_on_user_id_and_token", unique: true, using: :btree
    t.index ["user_id"], name: "index_firebase_tokens_on_user_id", using: :btree
  end

  create_table "impersonations", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "impersonated_user_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "in_progress_shifts", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "minute_start",         null: false
    t.integer  "minute_end",           null: false
    t.integer  "date",                 null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "location_id"
    t.integer  "user_id"
    t.integer  "scheduling_period_id"
    t.index ["company_id"], name: "index_in_progress_shifts_on_company_id", using: :btree
    t.index ["location_id"], name: "index_in_progress_shifts_on_location_id", using: :btree
    t.index ["scheduling_period_id"], name: "index_in_progress_shifts_on_scheduling_period_id", using: :btree
    t.index ["user_id"], name: "index_in_progress_shifts_on_user_id", using: :btree
  end

  create_table "leads", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "preferred_contact", default: 0, null: false
    t.text     "note"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["user_id"], name: "index_leads_on_user_id", using: :btree
  end

  create_table "locations", force: :cascade do |t|
    t.string   "line_1"
    t.string   "line_2"
    t.string   "line_3"
    t.string   "city"
    t.string   "county_province"
    t.string   "postalcode"
    t.string   "country"
    t.string   "additional_details"
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
    t.integer  "company_id",                                                         null: false
    t.string   "name"
    t.string   "time_zone",                   default: "Eastern Time (US & Canada)", null: false
    t.boolean  "use_custom_scheduling_rules", default: false,                        null: false
    t.string   "hash_key"
    t.index ["company_id"], name: "index_locations_on_company_id", using: :btree
  end

  create_table "manage_positions", force: :cascade do |t|
    t.integer "position_id"
    t.integer "manages_id",  null: false
    t.index ["position_id"], name: "index_manage_positions_on_position_id", using: :btree
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",                               null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",                          null: false
    t.string   "scopes"
    t.string   "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.string   "scopes",       default: "", null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "trade_id"
    t.string   "note"
    t.integer  "offered_shift_id"
    t.boolean  "accepted"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "user_id",                      null: false
    t.integer  "state",            default: 0, null: false
    t.index ["company_id"], name: "index_offers_on_company_id", using: :btree
    t.index ["trade_id"], name: "index_offers_on_trade_id", using: :btree
    t.index ["user_id"], name: "index_offers_on_user_id", using: :btree
  end

  create_table "popular_times", force: :cascade do |t|
    t.integer  "day_start"
    t.integer  "day_end"
    t.integer  "time_start"
    t.integer  "time_end"
    t.string   "holiday_name"
    t.integer  "level",        null: false
    t.string   "type",         null: false
    t.string   "popular_type", null: false
    t.integer  "popular_id",   null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "positions", force: :cascade do |t|
    t.integer  "company_id",                     null: false
    t.string   "name",                           null: false
    t.boolean  "company_admin",  default: false, null: false
    t.boolean  "location_admin", default: false, null: false
    t.datetime "deleted_at"
    t.index ["company_id"], name: "index_positions_on_company_id", using: :btree
  end

  create_table "preferences", force: :cascade do |t|
    t.integer "preferable_id",                               null: false
    t.integer "shift_overlap",           default: 15,        null: false
    t.integer "minimum_shift_length",    default: 240,       null: false
    t.integer "maximum_shift_length",    default: 480,       null: false
    t.integer "break_length",            default: 60,        null: false
    t.string  "preferable_type",         default: "Company", null: false
    t.boolean "use_company_settings",    default: true,      null: false
    t.boolean "paid_break",              default: false,     null: false
    t.integer "minimum_hours_for_break", default: 4,         null: false
    t.integer "preferred_shift_length",  default: 360,       null: false
    t.index ["preferable_id"], name: "index_preferences_on_preferable_id", using: :btree
  end

  create_table "preferred_hours", force: :cascade do |t|
    t.integer "user_id"
    t.integer "day"
    t.integer "start",   default: 0,    null: false
    t.integer "end",     default: 1440, null: false
    t.index ["user_id", "day"], name: "index_preferred_hours_on_user_id_and_day", unique: true, using: :btree
    t.index ["user_id"], name: "index_preferred_hours_on_user_id", using: :btree
  end

  create_table "schedule_rules", force: :cascade do |t|
    t.integer "ruleable_id",                             null: false
    t.integer "position_id",                             null: false
    t.integer "period",              default: 2,         null: false
    t.integer "number_of_employees", default: 1,         null: false
    t.string  "ruleable_type",       default: "Company", null: false
    t.integer "day"
    t.index ["position_id", "period", "day"], name: "index_schedule_rules_on_position_id_and_period_and_day", unique: true, using: :btree
    t.index ["position_id"], name: "index_schedule_rules_on_position_id", using: :btree
    t.index ["ruleable_id"], name: "index_schedule_rules_on_ruleable_id", using: :btree
    t.index ["ruleable_type", "ruleable_id"], name: "index_schedule_rules_on_ruleable_type_and_ruleable_id", using: :btree
  end

  create_table "schedule_settings", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "schedule_duration", default: 2, null: false
    t.integer  "day_start",         default: 1, null: false
    t.integer  "lead_time",         default: 2, null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "note"
    t.index ["company_id"], name: "index_schedule_settings_on_company_id", using: :btree
  end

  create_table "scheduled_task_runs", force: :cascade do |t|
    t.string   "name",         null: false
    t.boolean  "failed",       null: false
    t.text     "output"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "scheduling_hours", force: :cascade do |t|
    t.integer  "location_id"
    t.integer  "day",                      null: false
    t.integer  "minute_open_start",        null: false
    t.integer  "minute_open_end",          null: false
    t.integer  "minute_schedulable_start"
    t.integer  "minute_schedulable_end"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["location_id", "day"], name: "index_scheduling_hours_on_location_id_and_day", unique: true, using: :btree
    t.index ["location_id"], name: "index_scheduling_hours_on_location_id", using: :btree
  end

  create_table "scheduling_periods", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "location_id"
    t.integer  "start_date",              null: false
    t.integer  "end_date",                null: false
    t.integer  "status",      default: 0, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["company_id"], name: "index_scheduling_periods_on_company_id", using: :btree
    t.index ["location_id"], name: "index_scheduling_periods_on_location_id", using: :btree
  end

  create_table "shifts", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "minute_start",             null: false
    t.integer  "minute_end",               null: false
    t.integer  "date",                     null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "location_id",              null: false
    t.integer  "user_id",                  null: false
    t.integer  "state",        default: 0, null: false
    t.string   "note"
    t.index ["company_id"], name: "index_shifts_on_company_id", using: :btree
    t.index ["location_id"], name: "index_shifts_on_location_id", using: :btree
    t.index ["user_id"], name: "index_shifts_on_user_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "company_id"
    t.integer  "plan",                   default: 1, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "stripe_subscription_id"
    t.index ["company_id"], name: "index_subscriptions_on_company_id", using: :btree
  end

  create_table "time_off_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "start_date"
    t.integer  "start_minutes"
    t.integer  "end_minutes"
    t.integer  "end_date"
    t.integer  "status",        default: 0, null: false
    t.integer  "reviewed_by"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["user_id"], name: "index_time_off_requests_on_user_id", using: :btree
  end

  create_table "trades", force: :cascade do |t|
    t.integer  "shift_id",                         null: false
    t.integer  "location_id"
    t.string   "note",                             null: false
    t.boolean  "accept_offers",     default: true, null: false
    t.integer  "accepted_shift_id"
    t.integer  "status",            default: 0,    null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "user_id"
    t.integer  "traded_with_id"
    t.index ["location_id"], name: "index_trades_on_location_id", using: :btree
    t.index ["shift_id"], name: "index_trades_on_shift_id", using: :btree
    t.index ["user_id"], name: "index_trades_on_user_id", using: :btree
  end

  create_table "user_locations", force: :cascade do |t|
    t.integer "user_id",                     null: false
    t.integer "location_id",                 null: false
    t.boolean "home",        default: false
    t.boolean "admin",       default: false, null: false
    t.index ["location_id"], name: "index_user_locations_on_location_id", using: :btree
    t.index ["user_id", "location_id"], name: "index_user_locations_on_user_id_and_location_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_user_locations_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "company_id",                             null: false
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
    t.boolean  "company_admin",          default: false
    t.datetime "deleted_at"
    t.boolean  "scheduleless_admin",     default: false, null: false
    t.integer  "primary_position_id"
    t.string   "locale",                 default: "en",  null: false
    t.string   "hash_key"
    t.index ["company_id"], name: "index_users_on_company_id", using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "shifts", "locations"
  add_foreign_key "shifts", "users"
end
