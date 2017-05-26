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

ActiveRecord::Schema.define(version: 20170525184825) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "allocations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.decimal  "amount",     precision: 12, scale: 2, null: false
    t.integer  "group_id"
  end

  add_index "allocations", ["group_id"], name: "index_allocations_on_group_id", using: :btree
  add_index "allocations", ["user_id"], name: "index_allocations_on_user_id", using: :btree

  create_table "buckets", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "target"
    t.integer  "group_id"
    t.string   "status",            default: "draft"
    t.datetime "funding_closes_at"
    t.datetime "funded_at"
    t.datetime "live_at"
    t.datetime "archived_at"
    t.datetime "paid_at"
  end

  add_index "buckets", ["group_id"], name: "index_buckets_on_group_id", using: :btree
  add_index "buckets", ["user_id"], name: "index_buckets_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.string   "body",       null: false
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["bucket_id"], name: "index_comments_on_bucket_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "contributions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "bucket_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount",     null: false
  end

  add_index "contributions", ["bucket_id"], name: "index_contributions_on_bucket_id", using: :btree
  add_index "contributions", ["user_id"], name: "index_contributions_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "kind",           limit: 255
    t.integer  "eventable_id"
    t.string   "eventable_type"
    t.integer  "user_id"
    t.integer  "group_id"
    t.integer  "sequence_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id", using: :btree
  add_index "events", ["group_id", "sequence_id"], name: "index_events_on_group_id_and_sequence_id", unique: true, using: :btree
  add_index "events", ["group_id"], name: "index_events_on_group_id", using: :btree
  add_index "events", ["sequence_id"], name: "index_events_on_sequence_id", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_symbol", default: "$"
    t.string   "currency_code",   default: "USD"
    t.string   "customer_id"
    t.datetime "trial_end"
    t.string   "plan"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "group_id",                                   null: false
    t.integer  "member_id",                                  null: false
    t.boolean  "is_admin",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived_at"
    t.datetime "closed_member_help_card_at"
    t.datetime "closed_admin_help_card_at"
    t.datetime "saved_funds_at"
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["member_id"], name: "index_memberships_on_member_id", using: :btree

  create_table "subscription_trackers", force: :cascade do |t|
    t.integer  "user_id",                                             null: false
    t.boolean  "subscribed_to_email_notifications", default: false
    t.string   "email_digest_delivery_frequency",   default: "never"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
  end

  add_index "subscription_trackers", ["user_id"], name: "index_subscription_trackers_on_user_id", using: :btree

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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "tokens"
    t.string   "provider"
    t.string   "uid"
    t.string   "confirmation_token"
    t.integer  "utc_offset"
    t.datetime "confirmed_at"
    t.datetime "joined_first_group_at"
    t.boolean  "is_super_admin",         default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "webhooks", force: :cascade do |t|
    t.integer "hookable_id"
    t.string  "hookable_type"
    t.string  "kind",                       null: false
    t.string  "uri",                        null: false
    t.text    "event_types",   default: [],              array: true
  end

  add_index "webhooks", ["hookable_type", "hookable_id"], name: "index_webhooks_on_hookable_type_and_hookable_id", using: :btree

end
