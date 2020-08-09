# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_09_154103) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_trgm"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "record_id", null: false
    t.string "record_type", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "authie_sessions", id: :serial, force: :cascade do |t|
    t.string "token"
    t.string "browser_id"
    t.integer "user_id"
    t.boolean "active", default: true
    t.text "data"
    t.datetime "expires_at"
    t.datetime "login_at"
    t.string "login_ip"
    t.datetime "last_activity_at"
    t.string "last_activity_ip"
    t.string "last_activity_path"
    t.string "user_agent"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "user_type"
    t.integer "parent_id"
    t.datetime "two_factored_at"
    t.string "two_factored_ip"
    t.integer "requests", default: 0
    t.datetime "password_seen_at"
    t.string "token_hash"
    t.string "host"
    t.index ["browser_id"], name: "index_authie_sessions_on_browser_id"
    t.index ["token"], name: "index_authie_sessions_on_token"
    t.index ["token_hash"], name: "index_authie_sessions_on_token_hash"
    t.index ["user_id"], name: "index_authie_sessions_on_user_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "shortname"
    t.index ["game_id"], name: "index_categories_on_game_id"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "chat_messages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "race_id"
    t.bigint "user_id"
    t.boolean "from_entrant", null: false
    t.text "body", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["race_id"], name: "index_chat_messages_on_race_id"
    t.index ["user_id"], name: "index_chat_messages_on_user_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "race_id"
    t.bigint "runner_id"
    t.datetime "readied_at", precision: 3
    t.datetime "finished_at", precision: 3
    t.datetime "forfeited_at", precision: 3
    t.datetime "created_at", precision: 3, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.bigint "run_id"
    t.boolean "ghost", default: false, null: false
    t.bigint "creator_id"
    t.index ["creator_id"], name: "index_entries_on_creator_id"
    t.index ["race_id"], name: "index_entries_on_race_id"
    t.index ["run_id"], name: "index_entries_on_run_id"
    t.index ["runner_id"], name: "index_entries_on_runner_id"
  end

  create_table "game_aliases", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.citext "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_aliases_on_game_id"
    t.index ["name"], name: "index_game_aliases_on_name", unique: true
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_games_on_name"
  end

  create_table "google_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "google_id", null: false
    t.string "access_token", null: false
    t.datetime "access_token_expires_at", default: "1970-01-01 00:00:00", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "first_name", null: false
    t.string "last_name"
    t.string "avatar", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["google_id"], name: "index_google_users_on_google_id", unique: true
    t.index ["user_id"], name: "index_google_users_on_user_id"
  end

  create_table "highlight_suggestions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "run_id", null: false
    t.text "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id"], name: "index_highlight_suggestions_on_run_id", unique: true
  end

  create_table "oauth_access_grants", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.integer "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.string "code_challenge"
    t.string "code_challenge_method"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", id: :serial, force: :cascade do |t|
    t.integer "resource_owner_id"
    t.integer "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner_id"
    t.string "owner_type"
    t.datetime "secret_generated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.boolean "confidential", default: true, null: false
    t.index ["owner_id", "owner_type"], name: "index_oauth_applications_on_owner_id_and_owner_type"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "patreon_users", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "access_token", null: false
    t.string "refresh_token", null: false
    t.string "full_name", null: false
    t.string "patreon_id", null: false
    t.integer "pledge_cents", null: false
    t.datetime "pledge_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_patreon_users_on_user_id"
  end

  create_table "races", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "user_id"
    t.integer "visibility", default: 0, null: false
    t.string "join_token", null: false
    t.string "notes"
    t.datetime "started_at", precision: 3
    t.datetime "created_at", precision: 3, null: false
    t.datetime "updated_at", precision: 3, null: false
    t.bigint "game_id"
    t.index ["category_id"], name: "index_races_on_category_id"
    t.index ["game_id"], name: "index_races_on_game_id"
    t.index ["user_id"], name: "index_races_on_user_id"
  end

  create_table "rivalries", id: :serial, force: :cascade do |t|
    t.integer "category_id"
    t.integer "from_user_id"
    t.integer "to_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_rivalries_on_category_id"
    t.index ["from_user_id"], name: "index_rivalries_on_from_user_id"
    t.index ["to_user_id"], name: "index_rivalries_on_to_user_id"
  end

  create_table "run_histories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "run_id"
    t.integer "attempt_number"
    t.bigint "realtime_duration_ms"
    t.bigint "gametime_duration_ms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "started_at"
    t.datetime "ended_at"
    t.bigint "pause_duration_ms"
    t.index ["run_id"], name: "index_run_histories_on_run_id"
  end

  create_table "run_likes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "run_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["run_id", "user_id"], name: "index_run_likes_on_run_id_and_user_id", unique: true
    t.index ["run_id"], name: "index_run_likes_on_run_id"
    t.index ["user_id"], name: "index_run_likes_on_user_id"
  end

  create_table "runs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "nick"
    t.string "image_url"
    t.integer "category_id"
    t.string "program"
    t.string "claim_token"
    t.boolean "archived", default: false, null: false
    t.string "srdc_id"
    t.integer "attempts"
    t.string "s3_filename", null: false
    t.bigint "realtime_duration_ms"
    t.bigint "realtime_sum_of_best_ms"
    t.datetime "parsed_at"
    t.bigint "gametime_duration_ms"
    t.bigint "gametime_sum_of_best_ms"
    t.string "default_timing", default: "real", null: false
    t.bigint "total_playtime_ms"
    t.bigint "filesize_bytes", default: 0, null: false
    t.boolean "uses_emulator", default: false
    t.uuid "speedrun_dot_com_platform_id"
    t.uuid "speedrun_dot_com_region_id"
    t.boolean "uses_autosplitter"
    t.index ["category_id"], name: "index_runs_on_category_id"
    t.index ["s3_filename"], name: "index_runs_on_s3_filename"
    t.index ["user_id"], name: "index_runs_on_user_id"
  end

  create_table "segment_histories", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.uuid "segment_id"
    t.integer "attempt_number"
    t.bigint "realtime_duration_ms"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gametime_duration_ms"
    t.index ["segment_id"], name: "index_segment_histories_on_segment_id"
  end

  create_table "segments", id: :uuid, default: -> { "uuid_generate_v4()" }, force: :cascade do |t|
    t.integer "run_id", null: false
    t.integer "segment_number", null: false
    t.bigint "realtime_duration_ms"
    t.bigint "realtime_start_ms"
    t.bigint "realtime_end_ms"
    t.bigint "realtime_shortest_duration_ms"
    t.string "name"
    t.boolean "realtime_gold", default: false, null: false
    t.boolean "realtime_reduced", default: false, null: false
    t.boolean "realtime_skipped", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gametime_start_ms"
    t.bigint "gametime_end_ms"
    t.bigint "gametime_duration_ms"
    t.bigint "gametime_shortest_duration_ms"
    t.boolean "gametime_gold", default: false, null: false
    t.boolean "gametime_reduced", default: false, null: false
    t.boolean "gametime_skipped", default: false, null: false
    t.index ["run_id"], name: "index_segments_on_run_id"
  end

  create_table "speed_runs_live_games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "game_id"
    t.string "srl_id"
    t.string "name", null: false
    t.string "shortname", null: false
    t.float "popularity"
    t.integer "popularity_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_speed_runs_live_games_on_game_id", unique: true
    t.index ["shortname"], name: "index_speed_runs_live_games_on_shortname", unique: true
    t.index ["srl_id"], name: "index_speed_runs_live_games_on_srl_id", unique: true
  end

  create_table "speedrun_dot_com_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "category_id", null: false
    t.string "srdc_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.boolean "misc", null: false
    t.string "rules"
    t.integer "min_players", null: false
    t.integer "max_players", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_speedrun_dot_com_categories_on_category_id", unique: true
  end

  create_table "speedrun_dot_com_game_platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "speedrun_dot_com_game_id"
    t.uuid "speedrun_dot_com_platform_id"
    t.index ["speedrun_dot_com_game_id"], name: "index_srdc_game_platforms_on_srdc_games_id"
    t.index ["speedrun_dot_com_platform_id"], name: "index_srdc_game_platforms_on_srdc_platforms_id"
  end

  create_table "speedrun_dot_com_game_regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "speedrun_dot_com_game_id"
    t.uuid "speedrun_dot_com_region_id"
    t.index ["speedrun_dot_com_game_id"], name: "index_srdc_game_regions_on_srdc_games_id"
    t.index ["speedrun_dot_com_region_id"], name: "index_srdc_game_regions_on_srdc_regions_id"
  end

  create_table "speedrun_dot_com_game_variable_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "speedrun_dot_com_game_variable_id", null: false
    t.string "srdc_id", null: false
    t.string "label", null: false
    t.string "rules"
    t.boolean "miscellaneous"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["speedrun_dot_com_game_variable_id"], name: "index_srdc_game_variable_values_on_srdc_game_variables_id"
  end

  create_table "speedrun_dot_com_game_variables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "srdc_id"
    t.string "name", null: false
    t.uuid "speedrun_dot_com_game_id", null: false
    t.uuid "speedrun_dot_com_category_id"
    t.boolean "mandatory"
    t.boolean "obsoletes"
    t.boolean "user_defined"
    t.string "game_scope", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "speedrun_dot_com_game_variable_values_id"
    t.index ["speedrun_dot_com_category_id"], name: "index_srdc_game_variables_on_srdc_category_id"
    t.index ["speedrun_dot_com_game_id"], name: "index_srdc_game_variables_on_srdc_game_id"
    t.index ["speedrun_dot_com_game_variable_values_id"], name: "index_srdc_game_variables_on_srdc_game_variable_values_id"
  end

  create_table "speedrun_dot_com_games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "game_id"
    t.string "srdc_id", null: false
    t.string "name", null: false
    t.string "shortname"
    t.string "url", null: false
    t.string "favicon_url"
    t.string "cover_url"
    t.string "default_timing", null: false
    t.boolean "show_ms", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "twitch_name"
    t.boolean "video_required"
    t.boolean "accepts_realtime"
    t.boolean "accepts_gametime"
    t.boolean "emulators_allowed"
    t.index ["game_id"], name: "index_speedrun_dot_com_games_on_game_id", unique: true
    t.index ["shortname"], name: "index_speedrun_dot_com_games_on_shortname", unique: true
    t.index ["srdc_id"], name: "index_speedrun_dot_com_games_on_srdc_id", unique: true
  end

  create_table "speedrun_dot_com_platforms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "srdc_id", null: false
    t.string "name", null: false
  end

  create_table "speedrun_dot_com_regions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "srdc_id", null: false
    t.string "name", null: false
  end

  create_table "speedrun_dot_com_run_variables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "speedrun_dot_com_game_variable_value_id"
    t.bigint "run_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["run_id"], name: "index_speedrun_dot_com_run_variables_on_run_id"
    t.index ["speedrun_dot_com_game_variable_value_id"], name: "index_srdc_run_variables_on_srdc_game_variable_value_id"
  end

  create_table "speedrun_dot_com_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "srdc_id", null: false
    t.string "name", null: false
    t.string "url", null: false
    t.string "api_key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_key"], name: "index_speedrun_dot_com_users_on_api_key", unique: true
    t.index ["srdc_id"], name: "index_speedrun_dot_com_users_on_srdc_id", unique: true
    t.index ["user_id"], name: "index_speedrun_dot_com_users_on_user_id", unique: true
  end

  create_table "splits", id: :serial, force: :cascade do |t|
    t.integer "run_id"
    t.integer "position"
    t.string "name"
    t.float "real_duration"
    t.float "best_real_duration"
    t.float "game_duration"
    t.float "best_game_duration"
    t.index ["run_id"], name: "index_splits_on_run_id"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "stripe_session_id"
    t.string "stripe_plan_id", null: false
    t.string "stripe_subscription_id"
    t.string "stripe_payment_intent_id"
    t.string "stripe_customer_id"
    t.datetime "canceled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "ended_at"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "twitch_user_follows", force: :cascade do |t|
    t.bigint "from_user_id"
    t.bigint "to_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_user_id"], name: "index_twitch_user_follows_on_from_user_id"
    t.index ["to_user_id"], name: "index_twitch_user_follows_on_to_user_id"
  end

  create_table "twitch_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "access_token", null: false
    t.string "name", null: false
    t.string "display_name", null: false
    t.string "twitch_id", null: false
    t.string "email"
    t.string "avatar", null: false
    t.datetime "follows_synced_at", default: "1970-01-01 00:00:00", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url", null: false
    t.string "refresh_token"
    t.index ["twitch_id"], name: "index_twitch_users_on_twitch_id", unique: true
    t.index ["user_id"], name: "index_twitch_users_on_user_id", unique: true
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.citext "name"
    t.index ["name"], name: "index_users_on_name", unique: true
  end

  create_table "videos", force: :cascade do |t|
    t.bigint "run_id", null: false
    t.string "url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "start_offset_ms", default: 10000, null: false
    t.index ["run_id"], name: "index_videos_on_run_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chat_messages", "races"
  add_foreign_key "chat_messages", "users"
  add_foreign_key "entries", "races"
  add_foreign_key "entries", "users", column: "runner_id"
  add_foreign_key "game_aliases", "games", on_delete: :cascade
  add_foreign_key "google_users", "users"
  add_foreign_key "highlight_suggestions", "runs"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "patreon_users", "users"
  add_foreign_key "races", "categories"
  add_foreign_key "races", "games"
  add_foreign_key "races", "users"
  add_foreign_key "run_histories", "runs", on_delete: :cascade
  add_foreign_key "run_likes", "runs"
  add_foreign_key "run_likes", "users"
  add_foreign_key "runs", "speedrun_dot_com_platforms"
  add_foreign_key "runs", "speedrun_dot_com_regions"
  add_foreign_key "segment_histories", "segments", on_delete: :cascade
  add_foreign_key "segments", "runs", on_delete: :cascade
  add_foreign_key "speed_runs_live_games", "games"
  add_foreign_key "speedrun_dot_com_categories", "categories"
  add_foreign_key "speedrun_dot_com_game_platforms", "speedrun_dot_com_games"
  add_foreign_key "speedrun_dot_com_game_platforms", "speedrun_dot_com_platforms"
  add_foreign_key "speedrun_dot_com_game_regions", "speedrun_dot_com_games"
  add_foreign_key "speedrun_dot_com_game_regions", "speedrun_dot_com_regions"
  add_foreign_key "speedrun_dot_com_game_variable_values", "speedrun_dot_com_game_variables"
  add_foreign_key "speedrun_dot_com_game_variables", "speedrun_dot_com_categories"
  add_foreign_key "speedrun_dot_com_game_variables", "speedrun_dot_com_games"
  add_foreign_key "speedrun_dot_com_games", "games"
  add_foreign_key "speedrun_dot_com_run_variables", "runs"
  add_foreign_key "speedrun_dot_com_run_variables", "speedrun_dot_com_game_variable_values"
  add_foreign_key "speedrun_dot_com_users", "users"
  add_foreign_key "splits", "runs"
  add_foreign_key "twitch_users", "users"
end
