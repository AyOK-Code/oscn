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

ActiveRecord::Schema.define(version: 2021_04_13_015337) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "case_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cases", force: :cascade do |t|
    t.integer "oscn_id"
    t.bigint "county_id", null: false
    t.bigint "case_type_id", null: false
    t.string "case_number"
    t.date "filed_on"
    t.date "closed_on"
    t.text "html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["case_type_id"], name: "index_cases_on_case_type_id"
    t.index ["county_id"], name: "index_cases_on_county_id"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "fips_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "cases", "case_types"
  add_foreign_key "cases", "counties"
end
