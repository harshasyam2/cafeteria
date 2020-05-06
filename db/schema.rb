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

ActiveRecord::Schema.define(version: 2020_05_06_041219) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "customers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "role"
  end

  create_table "menuitems", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.bigint "menu_id"
  end

  create_table "menus", force: :cascade do |t|
    t.string "name"
  end

  create_table "orderitems", force: :cascade do |t|
    t.bigint "order_id"
    t.bigint "menuitem_id"
    t.string "menuitem_name"
    t.integer "menuitem_price"
    t.integer "no_of_items"
  end

  create_table "orders", force: :cascade do |t|
    t.date "date"
    t.integer "bill"
    t.string "status"
    t.bigint "customer_id"
  end

  create_table "todos", force: :cascade do |t|
    t.text "todo_text"
    t.date "due_date"
    t.boolean "completed"
    t.bigint "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
  end

end
