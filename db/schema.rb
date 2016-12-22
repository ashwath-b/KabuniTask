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

ActiveRecord::Schema.define(version: 20161220143101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "short_urls", force: true do |t|
    t.string   "original_url"
    t.string   "shorty"
    t.integer  "user_id"
    t.integer  "visits_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "short_visits", force: true do |t|
    t.integer  "short_url_id"
    t.string   "visitor_ip"
    t.string   "visitor_city"
    t.string   "visitor_state"
    t.string   "visitor_country_iso2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "auth_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
