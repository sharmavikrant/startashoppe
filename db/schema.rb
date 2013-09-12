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

ActiveRecord::Schema.define(:version => 20130905061721) do

  create_table "master_users", :primary_key => "master_user_id", :force => true do |t|
    t.string   "shop_name"
    t.string   "password"
    t.string   "master_email"
    t.boolean  "validate"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "master_users", ["shop_name"], :name => "index_master_users_on_shop_name", :unique => true

  create_table "masterusers", :primary_key => "master_user_id", :force => true do |t|
    t.string   "url_name"
    t.string   "password"
    t.string   "shop_name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "address"
    t.string   "landmark"
    t.string   "city"
    t.string   "state"
    t.string   "pincode"
    t.string   "country"
    t.string   "phone"
    t.string   "master_email"
    t.boolean  "validate"
    t.string   "theam"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "masterusers", ["master_email"], :name => "index_masterusers_on_master_email", :unique => true
  add_index "masterusers", ["url_name"], :name => "index_masterusers_on_url_name", :unique => true

end
