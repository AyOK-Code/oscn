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

ActiveRecord::Schema.define(version: 2021_10_18_184136) do

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
    t.index ["county_id", "oscn_id"], name: "index_court_cases_on_county_id_and_oscn_id", unique: true
    t.index ["county_id"], name: "index_court_cases_on_county_id"
    t.index ["current_judge_id"], name: "index_court_cases_on_current_judge_id"
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
    t.decimal "payment", default: "0.0", null: false
    t.decimal "adjustment", default: "0.0", null: false
    t.integer "row_index", null: false
    t.index ["adjustment"], name: "index_docket_events_on_adjustment"
    t.index ["amount"], name: "index_docket_events_on_amount", where: "(amount <> (0)::numeric)"
    t.index ["court_case_id"], name: "index_docket_events_on_court_case_id"
    t.index ["docket_event_type_id"], name: "index_docket_events_on_docket_event_type_id"
    t.index ["party_id"], name: "index_docket_events_on_party_id"
    t.index ["payment"], name: "index_docket_events_on_payment"
    t.index ["row_index", "court_case_id"], name: "index_docket_events_on_row_index_and_court_case_id", unique: true
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

  create_table "parent_parties", force: :cascade do |t|
    t.string "name"
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
    t.string "suffix"
    t.bigint "parent_party_id"
    t.index ["oscn_id"], name: "index_parties_on_oscn_id", unique: true
    t.index ["parent_party_id"], name: "index_parties_on_parent_party_id"
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

  create_table "titles", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "verdicts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_verdicts_on_name", unique: true
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
  add_foreign_key "docket_events", "court_cases"
  add_foreign_key "docket_events", "docket_event_types"
  add_foreign_key "docket_events", "parties"
  add_foreign_key "events", "court_cases"
  add_foreign_key "events", "parties"
  add_foreign_key "judges", "counties"
  add_foreign_key "parties", "parent_parties"
  add_foreign_key "parties", "party_types"
  add_foreign_key "party_addresses", "parties"

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
  create_view "report_fines_and_fees", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      case_types.id AS case_type_id,
      docket_event_types.id AS docket_event_types_id,
      docket_events.event_on,
      docket_events.amount,
      docket_events.payment,
      docket_events.adjustment,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events docket_events_1
                   JOIN docket_event_types docket_event_types_1 ON ((docket_events_1.docket_event_type_id = docket_event_types_1.id)))
                WHERE ((docket_events_1.court_case_id = court_cases.id) AND ((docket_event_types_1.code)::text = 'CTRS'::text))) > 0) THEN true
              ELSE false
          END AS is_tax_intercepted
     FROM (((docket_events
       JOIN docket_event_types ON ((docket_event_types.id = docket_events.docket_event_type_id)))
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
    WHERE ((docket_events.amount <> (0)::numeric) OR (docket_events.adjustment <> (0)::numeric) OR (docket_events.payment <> (0)::numeric));
  SQL
  add_index "report_fines_and_fees", ["case_type_id"], name: "index_report_fines_and_fees_on_case_type_id"
  add_index "report_fines_and_fees", ["court_case_id"], name: "index_report_fines_and_fees_on_court_case_id"
  add_index "report_fines_and_fees", ["docket_event_types_id"], name: "index_report_fines_and_fees_on_docket_event_types_id"
  add_index "report_fines_and_fees", ["event_on"], name: "index_report_fines_and_fees_on_event_on"

  create_view "report_arresting_agencies", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.case_number,
      a.parent_party_id AS arresting_agency_id,
          CASE
              WHEN (a.parent_parties_name IS NULL) THEN 'NOT PROVIDED'::character varying
              ELSE a.parent_parties_name
          END AS arresting_agency,
      case_types.abbreviation AS case_type,
      court_cases.filed_on,
      COALESCE(counts.as_filed, 'No Charges Filed'::character varying) AS charges_as_filed,
      COALESCE(counts.filed_statute_violation, 'No Charges Filed'::character varying) AS filed_statute_violation,
      ( SELECT (regexp_matches(split_part((counts.filed_statute_violation)::text, 'O.S.'::text, 1), '[0-9]{2}[A-Z]?'::text))[1] AS title_code
             FROM counts c2
            WHERE ((counts.court_case_id = court_cases.id) AND (counts.id = c2.id))) AS title_code
     FROM (((court_cases
       LEFT JOIN ( SELECT case_parties.court_case_id,
              parent_parties.id AS parent_party_id,
              parent_parties.name AS parent_parties_name
             FROM (((case_parties
               JOIN parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
               JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
            WHERE ((party_types.name)::text = 'arresting agency'::text)) a ON ((court_cases.id = a.court_case_id)))
       LEFT JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
       LEFT JOIN counts ON ((counts.court_case_id = court_cases.id)))
    WHERE ((case_types.abbreviation)::text <> 'CPC'::text);
  SQL
  add_index "report_arresting_agencies", ["arresting_agency_id"], name: "index_report_arresting_agencies_on_arresting_agency_id"
  add_index "report_arresting_agencies", ["filed_on"], name: "index_report_arresting_agencies_on_filed_on"
  add_index "report_arresting_agencies", ["title_code"], name: "index_report_arresting_agencies_on_title_code"

  create_view "party_stats", materialized: true, sql_definition: <<-SQL
      SELECT parties.id AS party_id,
      ( SELECT count(*) AS count
             FROM case_parties
            WHERE (case_parties.party_id = parties.id)) AS cases_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN court_cases ON ((case_parties.court_case_id = court_cases.id)))
               JOIN case_types ON ((case_types.id = court_cases.case_type_id)))
            WHERE ((case_parties.party_id = parties.id) AND ((case_types.abbreviation)::text = 'CF'::text))) AS cf_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN court_cases ON ((case_parties.court_case_id = court_cases.id)))
               JOIN case_types ON ((case_types.id = court_cases.case_type_id)))
            WHERE ((case_parties.party_id = parties.id) AND ((case_types.abbreviation)::text = 'CM'::text))) AS cm_count,
      ( SELECT count(*) AS count
             FROM (docket_events
               JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
            WHERE ((docket_events.party_id = parties.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) AS warrants_count,
      ( SELECT sum(docket_events.amount) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_fined,
      ( SELECT sum(docket_events.payment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_paid,
      ( SELECT sum(docket_events.adjustment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) AS total_adjusted,
      ((( SELECT sum(docket_events.amount) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id)) - ( SELECT sum(docket_events.payment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id))) - ( SELECT sum(docket_events.adjustment) AS sum
             FROM docket_events
            WHERE (docket_events.party_id = parties.id))) AS account_balance
     FROM (parties
       JOIN party_types ON ((parties.party_type_id = party_types.id)))
    WHERE ((party_types.name)::text = 'defendant'::text);
  SQL
  add_index "party_stats", ["party_id"], name: "index_party_stats_on_party_id"

  create_view "report_warrants", materialized: true, sql_definition: <<-SQL
      SELECT docket_events.id,
      docket_events.court_case_id,
      case_types.name,
      case_types.abbreviation,
      docket_events.party_id,
      docket_events.event_on,
      docket_event_types.code,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id))) = 1) THEN ( SELECT parent_parties.name
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id)))
              WHEN (( SELECT count(*) AS count
                 FROM ((((case_parties
                   JOIN parties ON ((case_parties.party_id = parties.id)))
                   JOIN parent_parties ON ((parties.parent_party_id = parent_parties.id)))
                   JOIN party_types ON ((parties.party_type_id = party_types.id)))
                   JOIN court_cases court_cases_1 ON ((court_cases_1.id = case_parties.court_case_id)))
                WHERE (((party_types.name)::text = 'arresting agency'::text) AND (court_cases_1.id = docket_events.court_case_id))) > 1) THEN 'MULTIPLE ARRESTING AGENCIES'::character varying
              ELSE 'NOT PROVIDED'::character varying
          END AS arresting_agency,
          CASE docket_event_types.code
              WHEN 'WAI$'::text THEN 'Warrant of Arrest Issued'::text
              WHEN 'BWIFAP'::text THEN 'Bench Warrant Issued - Failed to Appear and Pay'::text
              WHEN 'BWIFA'::text THEN 'Bench Warrant Issued - Failed to Appear'::text
              WHEN 'BWIFC'::text THEN 'Bench Warrant Issued - Failure to Comply'::text
              WHEN 'BWIAR'::text THEN 'Bench Warrant Issued - Application to Revoke'::text
              WHEN 'BWIAA'::text THEN 'Bench Warrant Issued - Application to Accelerate'::text
              WHEN 'BWICA'::text THEN 'Bench Warrant Issued - Cause'::text
              WHEN 'BWIFAR'::text THEN 'Bench Warrant Issued - Failure to Appear - Application to Revoke'::text
              WHEN 'BWIFAA'::text THEN 'Bench Warrant Issued - Failure To Appear - Application to Accelerate'::text
              WHEN 'BWIFP'::text THEN 'Bench Warrant Issued - Failed To Pay'::text
              WHEN 'BWIMW'::text THEN 'Bench Warrant Issued - Material Witness'::text
              WHEN 'BWIR8'::text THEN 'Bench Warrant Issued - Rule 8'::text
              WHEN 'BWIS'::text THEN 'Bench Warrant Issued - Service By Sheriff - No Money'::text
              WHEN 'BWIS$'::text THEN 'Bench Warrant Issued - Service By Sheriff'::text
              WHEN 'WAI'::text THEN 'Warrant of Arrest Issued - No Money'::text
              WHEN 'WAIMV'::text THEN 'Warrant of Arrest Issued - Material Warrant'::text
              WHEN 'WAIMW'::text THEN 'Warrant of Arrest Issued - Material Witness'::text
              WHEN 'RETBW'::text THEN 'Warrant Returned'::text
              WHEN 'RETWA'::text THEN 'Warrant Returned'::text
              ELSE NULL::text
          END AS shortdescription,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIFAR'::character varying])::text[])) THEN true
              ELSE false
          END AS is_failure_to_appear,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFAP'::text) THEN true
              ELSE false
          END AS is_failure_to_appear_and_pay,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFP'::text) THEN true
              ELSE false
          END AS is_failure_to_pay,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIFC'::text) THEN true
              ELSE false
          END AS is_failure_to_comply,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAA'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying])::text[])) THEN true
              ELSE false
          END AS is_bench_warrant_issued,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['WAI'::character varying, 'WAI$'::character varying])::text[])) THEN true
              ELSE false
          END AS is_arrest_warrant_issued,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIAA'::text) THEN true
              ELSE false
          END AS is_application_to_accelerate,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIAR'::text) THEN true
              ELSE false
          END AS is_application_to_revoke,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWICA'::text) THEN true
              ELSE false
          END AS is_cause,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIMW'::character varying, 'WAIMW'::character varying])::text[])) THEN true
              ELSE false
          END AS is_material_witness,
          CASE
              WHEN ((docket_event_types.code)::text = 'WAIMV'::text) THEN true
              ELSE false
          END AS is_material_warrant,
          CASE
              WHEN ((docket_event_types.code)::text = 'BWIR8'::text) THEN true
              ELSE false
          END AS is_material_rule_8,
          CASE
              WHEN ((docket_event_types.code)::text = ANY ((ARRAY['BWIS$'::character varying, 'BWIS'::character varying])::text[])) THEN true
              ELSE false
          END AS is_service_by_sheriff,
          CASE
              WHEN (docket_events.description ~~ '%CLEARED%'::text) THEN true
              ELSE false
          END AS is_cleared,
      ((( SELECT (regexp_matches(docket_events.description, '[0-9]{1,3}(?:,?[0-9]{3})*\.[0-9]{2}'::text))[1] AS regexp_matches))::money)::numeric AS bond_amount,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RETURNED \d{1,2}/\d{1,2}/\d{4}'::text) AS regexp_matches))[1], '\d{1,2}/\d{1,2}/\d{4}'::text))[1] AS regexp_matches) AS warrant_returned_on,
          CASE
              WHEN (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \d{1,2}/\d{1,2}/\d{4}'::text) AS regexp_matches))[1], '\d{1,2}/\d{1,2}/\d{4}'::text))[1] AS regexp_matches) IS NULL) THEN docket_events.event_on
              ELSE (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \d{1,2}/\d{1,2}/\d{4}'::text) AS regexp_matches))[1], '\d{1,2}/\d{1,2}/\d{4}'::text))[1] AS regexp_matches))::date
          END AS warrant_issued_on,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RECALLED \d{1,2}/\d{1,2}/\d{4}'::text) AS regexp_matches))[1], '\d{1,2}/\d{1,2}/\d{4}'::text))[1] AS regexp_matches) AS warrant_recalled_on,
      docket_events.description
     FROM (((docket_events
       JOIN docket_event_types ON ((docket_event_types.id = docket_events.docket_event_type_id)))
       JOIN court_cases ON ((court_cases.id = docket_events.court_case_id)))
       JOIN case_types ON ((court_cases.case_type_id = case_types.id)))
    WHERE ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWIFC'::character varying, 'BWIFAR'::character varying, 'BWICA'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'RETBW'::character varying, 'RETWA'::character varying])::text[]));
  SQL
  add_index "report_warrants", ["party_id", "code"], name: "index_report_warrants_on_party_id_and_code"

  create_view "report_searchable_cases", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.case_number,
      court_cases.filed_on,
      parties.full_name,
      parties.first_name,
      parties.last_name,
      parties.birth_month,
      parties.birth_year,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM report_warrants
                WHERE ((parties.id = report_warrants.party_id) AND ((report_warrants.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) > ( SELECT count(*) AS count
                 FROM report_warrants
                WHERE ((parties.id = report_warrants.party_id) AND ((report_warrants.code)::text = 'RETWA'::text)))) THEN 'Yes'::text
              ELSE 'No'::text
          END AS has_active_warrant,
      counts.offense_on AS date_of_offense,
      counts.as_filed AS count_as_filed,
      counts.charge AS count_as_disposed,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) > 0) THEN 'Yes'::text
              ELSE 'No'::text
          END AS warrant_on_case,
      pleas.name AS plea,
      verdicts.name AS verdict,
      (regexp_matches(split_part((counts.filed_statute_violation)::text, 'O.S.'::text, 1), '[0-9]{2}[A-Z]?'::text))[1] AS title_code
     FROM ((((counts
       JOIN court_cases ON ((counts.court_case_id = court_cases.id)))
       JOIN parties ON ((parties.id = counts.party_id)))
       JOIN pleas ON ((pleas.id = counts.plea_id)))
       JOIN verdicts ON ((verdicts.id = counts.verdict_id)));
  SQL
  add_index "report_searchable_cases", ["case_number"], name: "index_report_searchable_cases_on_case_number"
  add_index "report_searchable_cases", ["filed_on"], name: "index_report_searchable_cases_on_filed_on"
  add_index "report_searchable_cases", ["first_name"], name: "index_report_searchable_cases_on_first_name"
  add_index "report_searchable_cases", ["last_name"], name: "index_report_searchable_cases_on_last_name"

  create_view "case_stats", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      (court_cases.closed_on - court_cases.filed_on) AS length_of_case_in_days,
      ( SELECT count(*) AS count
             FROM counts
            WHERE (court_cases.id = counts.court_case_id)) AS counts_count,
      ( SELECT count(*) AS count
             FROM ((case_parties
               JOIN parties ON ((case_parties.party_id = parties.id)))
               JOIN party_types ON ((parties.party_type_id = party_types.id)))
            WHERE ((court_cases.id = case_parties.court_case_id) AND ((party_types.name)::text = 'defendant'::text))) AS defendant_count,
          CASE
              WHEN (( SELECT count(*) AS count
                 FROM (docket_events
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = 'CTRS'::text))) > 0) THEN true
              ELSE false
          END AS is_tax_intercepted,
      ( SELECT count(*) AS count
             FROM (docket_events
               JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
            WHERE ((docket_events.court_case_id = court_cases.id) AND ((docket_event_types.code)::text = ANY ((ARRAY['WAI$'::character varying, 'BWIFAP'::character varying, 'BWIFA'::character varying, 'BWIFC'::character varying, 'BWIAR'::character varying, 'BWIAA'::character varying, 'BWICA'::character varying, 'BWIFAR'::character varying, 'BWIFAA'::character varying, 'BWIFP'::character varying, 'BWIMW'::character varying, 'BWIR8'::character varying, 'BWIS'::character varying, 'BWIS$'::character varying, 'WAI'::character varying, 'WAIMV'::character varying, 'WAIMW'::character varying, 'BWIFAR'::character varying])::text[])))) AS warrants_count
     FROM court_cases;
  SQL
  add_index "case_stats", ["court_case_id"], name: "index_case_stats_on_court_case_id"

end
