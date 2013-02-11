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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130127001201) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "screen_name"
    t.string   "access_token"
    t.string   "access_secret"
    t.string   "bio"
    t.string   "image_url"
    t.string   "web_url"
    t.string   "last_tid"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "authentications", ["provider", "uid"], :name => "index_authentications_on_provider_and_uid", :unique => true
  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "game_maps", :force => true do |t|
    t.integer  "game_stage_id"
    t.integer  "type"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "game_maps", ["game_stage_id"], :name => "index_game_maps_on_game_stage_id"

  create_table "game_stages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "maps", :force => true do |t|
    t.integer  "stage_id"
    t.integer  "type"
    t.integer  "x"
    t.integer  "y"
    t.string   "move_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "maps", ["stage_id"], :name => "index_maps_on_stage_id"

  create_table "ranks", :force => true do |t|
    t.integer  "rank"
    t.integer  "score"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ranks", ["user_id"], :name => "index_ranks_on_user_id"

  create_table "stages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

end
