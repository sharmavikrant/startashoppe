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

  create_table "customer_1", :primary_key => "customer_id", :force => true do |t|
    t.string "user_name"
    t.string "password"
    t.string "first_name"
    t.string "last_name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "pincode"
    t.string "country"
    t.string "phone"
    t.string "order_id"
  end

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

  create_table "order_1", :primary_key => "order_id", :force => true do |t|
    t.string   "product_id"
    t.integer  "customer_id"
    t.string   "name"
    t.string   "address"
    t.string   "pincode"
    t.string   "state"
    t.string   "city"
    t.string   "land_mark"
    t.string   "country"
    t.string   "phone"
    t.string   "email"
    t.datetime "order_date"
    t.integer  "total_amt"
    t.date     "delivery_date"
    t.string   "cod_confirm"
    t.string   "payment_mode"
    t.string   "payment_status"
    t.string   "order_status"
    t.boolean  "canceled"
    t.string   "canceled_reason", :limit => 1000
  end

  create_table "product_1", :primary_key => "product_id", :force => true do |t|
    t.string  "product_name"
    t.integer "product_category_id",                                :null => false
    t.integer "sub_category_id",                                    :null => false
    t.integer "price",                                              :null => false
    t.integer "sale_price",                                         :null => false
    t.integer "quantity",                                           :null => false
    t.string  "title"
    t.string  "description",         :limit => 2000
    t.string  "image_1"
    t.string  "image_2"
    t.string  "image_3"
    t.boolean "shipping"
    t.boolean "comment"
    t.integer "revised_price"
    t.integer "out_quantity",                        :default => 0
  end

  create_table "product_category_1", :primary_key => "product_category_id", :force => true do |t|
    t.string "product_category_name", :null => false
  end

  add_index "product_category_1", ["product_category_name"], :name => "sqlite_autoindex_product_category_1_1", :unique => true

  create_table "product_order_1", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "order_id"
    t.string  "quantity"
  end

  create_table "product_sub_category_1", :primary_key => "sub_category_id", :force => true do |t|
    t.integer "product_category_id", :null => false
    t.string  "sub_category_name"
  end

end
