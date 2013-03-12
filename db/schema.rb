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

ActiveRecord::Schema.define(:version => 20130311095618) do

  create_table "items", :force => true do |t|
    t.integer  "shop_id"
    t.integer  "order_id"
    t.boolean  "ordered",    :default => false
    t.string   "name"
    t.decimal  "price"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "items_shopping_lists", :id => false, :force => true do |t|
    t.integer "item_id"
    t.integer "shopping_list_id"
  end

  create_table "orders", :force => true do |t|
    t.integer  "buyer_id"
    t.integer  "seller_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "shopping_lists", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.boolean  "ordered"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.boolean  "temp"
  end

  create_table "shops", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.boolean  "temp",            :default => false
    t.string   "password_digest"
    t.string   "password_salt"
    t.integer  "active_list_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "auth_token"
  end

end
