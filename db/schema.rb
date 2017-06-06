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

ActiveRecord::Schema.define(version: 20170605194326) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "uuid-ossp"

  create_table "authie_sessions", force: :cascade do |t|
    t.string   "token"
    t.string   "browser_id"
    t.integer  "user_id"
    t.boolean  "active",             default: true
    t.text     "data"
    t.datetime "expires_at"
    t.datetime "login_at"
    t.string   "login_ip"
    t.datetime "last_activity_at"
    t.string   "last_activity_ip"
    t.string   "last_activity_path"
    t.string   "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_type"
    t.integer  "parent_id"
    t.datetime "two_factored_at"
    t.string   "two_factored_ip"
    t.integer  "requests",           default: 0
    t.datetime "password_seen_at"
    t.string   "token_hash"
    t.index ["browser_id"], name: "index_authie_sessions_on_browser_id", using: :btree
    t.index ["token"], name: "index_authie_sessions_on_token", using: :btree
    t.index ["token_hash"], name: "index_authie_sessions_on_token_hash", using: :btree
    t.index ["user_id"], name: "index_authie_sessions_on_user_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
    t.index ["game_id"], name: "index_categories_on_game_id", using: :btree
    t.index ["name"], name: "index_categories_on_name", using: :btree
  end

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
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "game_aliases", force: :cascade do |t|
    t.integer "game_id"
    t.citext  "name"
    t.index ["game_id"], name: "index_game_aliases_on_game_id", using: :btree
    t.index ["name"], name: "index_game_aliases_on_name", unique: true, using: :btree
  end

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
    t.index ["name"], name: "index_games_on_name", using: :btree
    t.index ["shortname"], name: "index_games_on_shortname", using: :btree
  end

  create_table "rivalries", force: :cascade do |t|
    t.integer "category_id"
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.index ["category_id"], name: "index_rivalries_on_category_id", using: :btree
    t.index ["from_user_id"], name: "index_rivalries_on_from_user_id", using: :btree
    t.index ["to_user_id"], name: "index_rivalries_on_to_user_id", using: :btree
  end

  create_table "run_files", force: :cascade do |t|
    t.string "digest"
    t.text   "file"
    t.index ["digest"], name: "index_run_files_on_digest", using: :btree
  end

  create_table "runs", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nick"
    t.string   "image_url"
    t.integer  "category_id"
    t.decimal  "time"
    t.string   "program"
    t.boolean  "visited",                  default: false, null: false
    t.string   "claim_token"
    t.decimal  "sum_of_best"
    t.boolean  "archived",                 default: false, null: false
    t.string   "video_url"
    t.string   "run_file_digest"
    t.string   "srdc_id"
    t.integer  "attempts"
    t.string   "s3_filename"
    t.bigint   "duration_milliseconds"
    t.bigint   "sum_of_best_milliseconds"
    t.index ["category_id"], name: "index_runs_on_category_id", using: :btree
    t.index ["user_id"], name: "index_runs_on_user_id", using: :btree
  end

  create_table "segment_histories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid     "segment_id"
    t.integer  "attempt_number"
    t.bigint   "duration_milliseconds"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["segment_id"], name: "index_segment_histories_on_segment_id", using: :btree
  end

  create_table "segments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer  "run_id",                         null: false
    t.integer  "segment_number",                 null: false
    t.bigint   "duration_milliseconds",          null: false
    t.bigint   "start_milliseconds",             null: false
    t.bigint   "end_milliseconds",               null: false
    t.bigint   "shortest_duration_milliseconds", null: false
    t.string   "name",                           null: false
    t.boolean  "gold",                           null: false
    t.boolean  "reduced",                        null: false
    t.boolean  "skipped",                        null: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["run_id"], name: "index_segments_on_run_id", using: :btree
  end

  create_table "splits", force: :cascade do |t|
    t.integer "run_id"
    t.integer "position"
    t.string  "name"
    t.float   "real_duration"
    t.float   "best_real_duration"
    t.float   "game_duration"
    t.float   "best_game_duration"
    t.index ["run_id"], name: "index_splits_on_run_id", using: :btree
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "user_id"
    t.string  "stripe_subscription_id"
    t.string  "stripe_plan_id"
    t.string  "stripe_customer_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",               default: ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitch_token"
    t.integer  "twitch_id"
    t.string   "name"
    t.string   "avatar"
    t.boolean  "permagold"
    t.string   "twitch_display_name"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

  add_foreign_key "game_aliases", "games", on_delete: :cascade
  add_foreign_key "segment_histories", "segments", on_delete: :cascade
  add_foreign_key "segments", "runs", on_delete: :cascade
  add_foreign_key "splits", "runs"
end
