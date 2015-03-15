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

ActiveRecord::Schema.define(version: 20150215005207) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.integer  "game_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
  end

  add_index "categories", ["game_id"], name: "index_categories_on_game_id", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", using: :btree

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

  create_table "games", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shortname"
    t.integer  "srl_id"
  end

  add_index "games", ["name"], name: "index_games_on_name", using: :btree
  add_index "games", ["shortname"], name: "index_games_on_shortname", using: :btree

  create_table "rivalries", force: :cascade do |t|
    t.integer "category_id"
    t.integer "from_user_id"
    t.integer "to_user_id"
  end

  add_index "rivalries", ["category_id"], name: "index_rivalries_on_category_id", using: :btree
  add_index "rivalries", ["from_user_id"], name: "index_rivalries_on_from_user_id", using: :btree
  add_index "rivalries", ["to_user_id"], name: "index_rivalries_on_to_user_id", using: :btree

  create_table "run_files", force: :cascade do |t|
    t.string "digest"
    t.text   "file"
  end

  add_index "run_files", ["digest"], name: "index_run_files_on_digest", using: :btree

  create_table "runs", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "nick"
    t.string   "image_url"
    t.integer  "category_id"
    t.text     "file"
    t.string   "name"
    t.decimal  "time"
    t.string   "program"
    t.boolean  "visited",         default: false, null: false
    t.string   "claim_token"
    t.decimal  "sum_of_best"
    t.boolean  "archived"
    t.string   "video_url"
    t.string   "run_file_digest"
  end

  add_index "runs", ["category_id"], name: "index_runs_on_category_id", using: :btree
  add_index "runs", ["user_id"], name: "index_runs_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: ""
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "twitch_token"
    t.integer  "twitch_id"
    t.string   "name"
    t.string   "avatar"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
