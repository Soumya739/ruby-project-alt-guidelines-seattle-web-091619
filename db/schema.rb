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

ActiveRecord::Schema.define(version: 5) do

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.float "price"
    t.integer "store_id"
  end

  create_table "ordered_items", force: :cascade do |t|
    t.integer "order_id"
    t.integer "item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "order_date"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "location"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.integer "contact_num"
  end

end
