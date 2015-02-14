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

ActiveRecord::Schema.define(:version => 20150214201713) do

  create_table "digest_rails_digests", :force => true do |t|
    t.string   "key"
    t.string   "menu_name_high"
    t.integer  "menu_index_high"
    t.string   "menu_name_med"
    t.integer  "menu_index_med"
    t.string   "menu_name_low"
    t.integer  "menu_index_low"
    t.integer  "data_length"
    t.string   "engine"
    t.string   "route_name"
    t.binary   "data",            :limit => 10485760
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

end
