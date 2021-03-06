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

ActiveRecord::Schema.define(version: 20190116161416) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "name"
    t.string "unit"
    t.integer "quantity"
    t.string "uuid"
    t.boolean "optional", default: false
    t.string "emoji"
  end

  create_table "meal_ingredients", force: :cascade do |t|
    t.bigint "meal_id"
    t.bigint "ingredient_id"
    t.string "uuid"
    t.index ["ingredient_id"], name: "index_meal_ingredients_on_ingredient_id"
    t.index ["meal_id"], name: "index_meal_ingredients_on_meal_id"
  end

  create_table "meals", force: :cascade do |t|
    t.string "name"
    t.bigint "time_period_id"
    t.string "uuid"
    t.string "emoji"
    t.index ["time_period_id"], name: "index_meals_on_time_period_id"
  end

  create_table "time_periods", force: :cascade do |t|
    t.string "name"
    t.string "uuid"
    t.string "emoji"
  end

end
