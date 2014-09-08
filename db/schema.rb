# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140908024740) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_admin_notes_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "api_integrations", force: true do |t|
    t.string   "provider"
    t.string   "app"
    t.string   "key"
    t.string   "secret"
    t.string   "oauth_token"
    t.string   "oauth_secret"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "location_settings_id"
  end

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.text     "uid"
    t.text     "token"
    t.text     "name"
    t.text     "secret"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "checkin",    default: true
    t.text     "profile"
  end

  create_table "checkin_statuses", force: true do |t|
    t.string   "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lobby_messages", force: true do |t|
    t.string   "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_settings", force: true do |t|
    t.string   "name"
    t.boolean  "freeday"
    t.float    "daypass_price"
    t.float    "daypass_discount"
    t.string   "sender_email"
    t.string   "notification_email"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.decimal  "daypass_price3"
    t.decimal  "daypass_price5"
    t.string   "membership_plans_url"
    t.string   "main_site_url"
    t.string   "location_description"
    t.string   "logo_url"
    t.string   "mailer_host"
    t.integer  "membership_id"
    t.string   "corporate_name"
    t.text     "user_agreement"
  end

  create_table "memberships", force: true do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.boolean  "self_service"
    t.float    "price"
    t.boolean  "deducts_daypass",   default: true
    t.boolean  "discounts_daypass", default: true
    t.float    "daypass_discount"
    t.integer  "monthly_passes",    default: 0
  end

  create_table "pass_transfers", force: true do |t|
    t.string   "to_email"
    t.string   "redeem_code"
    t.integer  "quantity"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "pass_transfers", ["user_id"], name: "index_pass_transfers_on_user_id", using: :btree

  create_table "payment_transactions", force: true do |t|
    t.integer  "user_id"
    t.string   "transaction_type"
    t.float    "amount"
    t.string   "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "data"
    t.datetime "transaction_date"
    t.string   "transaction_key"
    t.integer  "transfer_id"
  end

  create_table "tweet_backs", force: true do |t|
    t.string   "tweet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_statuses", force: true do |t|
    t.integer  "user_id"
    t.string   "comment"
    t.integer  "checkin_status_id"
    t.boolean  "checkin"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "users", force: true do |t|
    t.string   "email",                        default: "", null: false
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "provider"
    t.string   "uid"
    t.string   "stripe_id"
    t.string   "name"
    t.integer  "membership_id"
    t.string   "avatar"
    t.string   "badge"
    t.boolean  "agreement"
    t.integer  "daypass_balance",              default: 0
    t.string   "badge_user_id"
    t.integer  "last_status_id"
    t.string   "company_name"
    t.string   "mailbox_number"
    t.string   "phone"
    t.string   "avatar_attached_file_name"
    t.string   "avatar_attached_content_type"
    t.integer  "avatar_attached_file_size"
    t.datetime "avatar_attached_updated_at"
    t.integer  "monthly_passes",               default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wiki_page_versions", force: true do |t|
    t.integer  "page_id",    null: false
    t.integer  "updator_id"
    t.integer  "number"
    t.string   "comment"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "updated_at"
  end

  add_index "wiki_page_versions", ["page_id"], name: "index_wiki_page_versions_on_page_id", using: :btree
  add_index "wiki_page_versions", ["updator_id"], name: "index_wiki_page_versions_on_updator_id", using: :btree

  create_table "wiki_pages", force: true do |t|
    t.integer  "creator_id"
    t.integer  "updator_id"
    t.string   "path"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wiki_pages", ["creator_id"], name: "index_wiki_pages_on_creator_id", using: :btree
  add_index "wiki_pages", ["path"], name: "index_wiki_pages_on_path", unique: true, using: :btree

end
