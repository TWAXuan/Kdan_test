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

ActiveRecord::Schema.define(version: 2020_09_27_091642) do

  create_table "store_books", force: :cascade do |t|
    t.integer "store_id"
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.decimal "cashbalance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "mon_open"
    t.string "mon_close"
    t.string "tues_open"
    t.string "tues_close"
    t.string "wed_open"
    t.string "wed_close"
    t.string "thurs_open"
    t.string "thurs_close"
    t.string "fri_open"
    t.string "fri_close"
    t.string "sat_open"
    t.string "sat_close"
    t.string "sun_open"
    t.string "sun_close"
  end

  create_table "user_purchase_histories", force: :cascade do |t|
    t.decimal "transaction_amount"
    t.datetime "transaction_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id"
    t.string "books_name"
    t.string "store_name"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.decimal "cashbalance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
