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

ActiveRecord::Schema.define(version: 20161208135857) do

  create_table "barbell_exercises", force: :cascade do |t|
    t.string "name"
    t.string "barbell"
  end

  create_table "beforeafter_stories", force: :cascade do |t|
    t.string "name"
    t.text   "story"
    t.string "photo_url"
  end

  create_table "bodybuilder_quotes", force: :cascade do |t|
    t.string "name"
    t.text   "quote"
    t.string "photo_url"
  end

  create_table "cardio_exercises", force: :cascade do |t|
    t.string "name"
    t.string "cardio"
  end

  create_table "dumbbell_exercises", force: :cascade do |t|
    t.string "dumbbell"
    t.string "name"
  end

  create_table "teams", force: :cascade do |t|
    t.string  "access_token"
    t.string  "team_name"
    t.string  "team_id"
    t.string  "user_id"
    t.text    "raw_json"
    t.string  "incoming_webhook"
    t.string  "incoming_channel"
    t.string  "bot_token"
    t.string  "bot_user_id"
    t.boolean "is_active",        default: true
  end

end
