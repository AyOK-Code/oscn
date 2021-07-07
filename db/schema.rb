# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_07_07_174739) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "case_htmls", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.datetime "scraped_at"
    t.text "html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["court_case_id"], name: "index_case_htmls_on_court_case_id"
  end

  create_table "case_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["court_case_id", "party_id"], name: "index_case_parties_on_court_case_id_and_party_id", unique: true
    t.index ["court_case_id"], name: "index_case_parties_on_court_case_id"
    t.index ["party_id", "court_case_id"], name: "index_case_parties_on_party_id_and_court_case_id", unique: true
    t.index ["party_id"], name: "index_case_parties_on_party_id"
  end

  create_table "case_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "name", null: false
    t.string "abbreviation", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "counsel_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.bigint "counsel_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["counsel_id"], name: "index_counsel_parties_on_counsel_id"
    t.index ["court_case_id"], name: "index_counsel_parties_on_court_case_id"
    t.index ["party_id"], name: "index_counsel_parties_on_party_id"
  end

  create_table "counsels", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "bar_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "city"
    t.string "state"
    t.string "member_type"
    t.string "member_status"
    t.date "admit_date"
    t.boolean "ok_bar", default: false, null: false
    t.index ["bar_number"], name: "index_counsels_on_bar_number", unique: true, where: "(bar_number IS NOT NULL)"
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "fips_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "counts", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.date "offense_on"
    t.string "as_filed"
    t.string "filed_statute_violation"
    t.string "disposition"
    t.date "disposition_on"
    t.string "disposed_statute_violation"
    t.bigint "plea_id"
    t.bigint "verdict_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "charge"
    t.index ["court_case_id"], name: "index_counts_on_court_case_id"
    t.index ["party_id"], name: "index_counts_on_party_id"
    t.index ["plea_id"], name: "index_counts_on_plea_id"
    t.index ["verdict_id"], name: "index_counts_on_verdict_id"
  end

  create_table "court_cases", force: :cascade do |t|
    t.integer "oscn_id"
    t.bigint "county_id", null: false
    t.bigint "case_type_id", null: false
    t.string "case_number"
    t.date "filed_on"
    t.date "closed_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.jsonb "logs"
    t.bigint "current_judge_id"
    t.index ["case_type_id"], name: "index_court_cases_on_case_type_id"
    t.index ["county_id"], name: "index_court_cases_on_county_id"
    t.index ["current_judge_id"], name: "index_court_cases_on_current_judge_id"
    t.index ["oscn_id"], name: "index_court_cases_on_oscn_id", unique: true
  end

  create_table "docket_event_fees", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.decimal "amount", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["docket_event_id"], name: "index_docket_event_fees_on_docket_event_id"
  end

  create_table "docket_event_types", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_docket_event_types_on_code", unique: true
  end

  create_table "docket_events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.date "event_on"
    t.bigint "docket_event_type_id", null: false
    t.text "description"
    t.decimal "amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "party_id"
    t.integer "count"
    t.decimal "payment", default: "0.0"
    t.decimal "adjustment", default: "0.0"
    t.integer "row_index", null: false
    t.index ["adjustment"], name: "index_docket_events_on_adjustment"
    t.index ["amount"], name: "index_docket_events_on_amount", where: "(amount <> (0)::numeric)"
    t.index ["court_case_id"], name: "index_docket_events_on_court_case_id"
    t.index ["docket_event_type_id"], name: "index_docket_events_on_docket_event_type_id"
    t.index ["party_id"], name: "index_docket_events_on_party_id"
    t.index ["payment"], name: "index_docket_events_on_payment"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id"
    t.datetime "event_at", null: false
    t.string "event_type", null: false
    t.string "docket"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["court_case_id"], name: "index_events_on_court_case_id"
    t.index ["party_id"], name: "index_events_on_party_id"
  end

  create_table "judges", force: :cascade do |t|
    t.string "name", null: false
    t.string "courthouse"
    t.string "judge_type", null: false
    t.bigint "county_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["county_id"], name: "index_judges_on_county_id"
  end

  create_table "oklahoma_statutes", force: :cascade do |t|
    t.string "code"
    t.string "ten_digit"
    t.string "severity"
    t.text "description"
    t.date "effective_on"
    t.string "update_status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "parties", force: :cascade do |t|
    t.integer "oscn_id"
    t.string "full_name"
    t.bigint "party_type_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "birth_month"
    t.integer "birth_year"
    t.index ["oscn_id"], name: "index_parties_on_oscn_id", unique: true
    t.index ["party_type_id"], name: "index_parties_on_party_type_id"
  end

  create_table "party_addresses", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "record_on"
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "address_type"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["party_id"], name: "index_party_addresses_on_party_id"
  end

  create_table "party_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_party_types_on_name", unique: true
  end

  create_table "pleas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_pleas_on_name", unique: true
  end

  create_table "verdicts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_verdicts_on_name", unique: true
  end

  create_table "warrants", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.bigint "judge_id"
    t.integer "bond"
    t.string "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["docket_event_id"], name: "index_warrants_on_docket_event_id"
    t.index ["judge_id"], name: "index_warrants_on_judge_id"
  end

  add_foreign_key "case_htmls", "court_cases"
  add_foreign_key "case_parties", "court_cases"
  add_foreign_key "case_parties", "parties"
  add_foreign_key "counsel_parties", "counsels"
  add_foreign_key "counsel_parties", "court_cases"
  add_foreign_key "counsel_parties", "parties"
  add_foreign_key "counts", "court_cases"
  add_foreign_key "counts", "parties"
  add_foreign_key "counts", "pleas"
  add_foreign_key "counts", "verdicts"
  add_foreign_key "court_cases", "case_types"
  add_foreign_key "court_cases", "counties"
  add_foreign_key "court_cases", "judges", column: "current_judge_id"
  add_foreign_key "docket_event_fees", "docket_events"
  add_foreign_key "docket_events", "court_cases"
  add_foreign_key "docket_events", "docket_event_types"
  add_foreign_key "docket_events", "parties"
  add_foreign_key "events", "court_cases"
  add_foreign_key "events", "parties"
  add_foreign_key "judges", "counties"
  add_foreign_key "parties", "party_types"
  add_foreign_key "party_addresses", "parties"
  add_foreign_key "warrants", "docket_events"
  add_foreign_key "warrants", "judges"

  create_view "case_stats", sql_definition: <<-SQL
      SELECT court_cases.id,
      (court_cases.closed_on - court_cases.filed_on) AS length_of_case_in_days,
      ( SELECT count(*) AS count
             FROM counts
            WHERE (court_cases.id = counts.court_case_id)) AS counts_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((court_cases.id = case_parties.court_case_id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count
     FROM court_cases;
  SQL
  create_view "payments", sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      docket_events.party_id,
      sum(docket_events.amount) AS total,
      sum(docket_events.payment) AS payment,
      sum(docket_events.adjustment) AS adjustment,
      ((sum(docket_events.amount) - sum(docket_events.adjustment)) - sum(docket_events.payment)) AS owed
     FROM (((docket_events
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN parties ON ((docket_events.party_id = parties.id)))
       JOIN party_types ON ((parties.party_type_id = party_types.id)))
    WHERE ((party_types.name)::text = 'defendant'::text)
    GROUP BY docket_events.party_id, court_cases.id;
  SQL
end
