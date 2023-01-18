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

ActiveRecord::Schema.define(version: 2023_01_17_182057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.bigint "roster_id"
    t.index ["court_case_id", "party_id"], name: "index_case_parties_on_court_case_id_and_party_id", unique: true
    t.index ["court_case_id"], name: "index_case_parties_on_court_case_id"
    t.index ["party_id", "court_case_id"], name: "index_case_parties_on_party_id_and_court_case_id", unique: true
    t.index ["party_id"], name: "index_case_parties_on_party_id"
    t.index ["roster_id"], name: "index_case_parties_on_roster_id"
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

  create_table "count_codes", force: :cascade do |t|
    t.string "code", null: false
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_count_codes_on_code", unique: true
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "fips_code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "district_attorney_id"
    t.index ["district_attorney_id"], name: "index_counties_on_district_attorney_id"
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
    t.bigint "filed_statute_code_id"
    t.bigint "disposed_statute_code_id"
    t.index ["court_case_id"], name: "index_counts_on_court_case_id"
    t.index ["disposed_statute_code_id"], name: "index_counts_on_disposed_statute_code_id"
    t.index ["filed_statute_code_id"], name: "index_counts_on_filed_statute_code_id"
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
    t.boolean "is_error", default: false, null: false
    t.index ["case_type_id"], name: "index_court_cases_on_case_type_id"
    t.index ["county_id", "oscn_id"], name: "index_court_cases_on_county_id_and_oscn_id", unique: true
    t.index ["county_id"], name: "index_court_cases_on_county_id"
    t.index ["current_judge_id"], name: "index_court_cases_on_current_judge_id"
  end

  create_table "district_attorneys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "doc_aliases", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.integer "doc_number"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["doc_profile_id", "doc_number", "last_name", "first_name", "middle_name", "suffix"], name: "alias_index", unique: true
    t.index ["doc_profile_id"], name: "index_doc_aliases_on_doc_profile_id"
  end

  create_table "doc_facilities", force: :cascade do |t|
    t.string "name"
    t.boolean "is_prison", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "doc_offense_codes", force: :cascade do |t|
    t.string "statute_code", null: false
    t.string "description", null: false
    t.boolean "is_violent", default: false, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["statute_code", "description", "is_violent"], name: "doc_offense_codes_index", unique: true
    t.index ["statute_code", "description", "is_violent"], name: "offense_code_index", unique: true
  end

  create_table "doc_profiles", force: :cascade do |t|
    t.integer "doc_number", null: false
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.date "last_move_date"
    t.string "facility"
    t.date "birth_date"
    t.integer "sex"
    t.string "race"
    t.string "hair"
    t.string "height_ft"
    t.string "height_in"
    t.string "weight"
    t.string "eye"
    t.integer "status"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "doc_facility_id"
    t.bigint "roster_id"
    t.index ["doc_facility_id"], name: "index_doc_profiles_on_doc_facility_id"
    t.index ["doc_number"], name: "index_doc_profiles_on_doc_number", unique: true
    t.index ["roster_id"], name: "index_doc_profiles_on_roster_id"
  end

  create_table "doc_sentences", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.bigint "doc_offense_code_id"
    t.string "statute_code"
    t.string "sentencing_county"
    t.date "js_date"
    t.string "crf_number"
    t.decimal "incarcerated_term_in_years"
    t.decimal "probation_term_in_years"
    t.boolean "is_death_sentence", default: false, null: false
    t.boolean "is_life_sentence", default: false, null: false
    t.boolean "is_life_no_parole_sentence", default: false, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "court_case_id"
    t.string "sentence_id", null: false
    t.string "consecutive_to_sentence_id"
    t.bigint "doc_sentencing_county_id"
    t.index ["court_case_id"], name: "index_doc_sentences_on_court_case_id"
    t.index ["doc_offense_code_id"], name: "index_doc_sentences_on_doc_offense_code_id"
    t.index ["doc_profile_id", "sentence_id"], name: "index_doc_sentences_on_doc_profile_id_and_sentence_id", unique: true
    t.index ["doc_profile_id"], name: "index_doc_sentences_on_doc_profile_id"
    t.index ["doc_sentencing_county_id"], name: "index_doc_sentences_on_doc_sentencing_county_id"
  end

  create_table "doc_sentencing_counties", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "county_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["county_id"], name: "index_doc_sentencing_counties_on_county_id"
  end

  create_table "doc_statuses", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.string "facility", null: false
    t.date "date"
    t.string "reason"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "doc_facility_id"
    t.index ["doc_facility_id"], name: "index_doc_statuses_on_doc_facility_id"
    t.index ["doc_profile_id", "date", "facility"], name: "status_index", unique: true
    t.index ["doc_profile_id", "doc_facility_id"], name: "index_doc_statuses_on_doc_profile_id_and_doc_facility_id", unique: true
    t.index ["doc_profile_id"], name: "index_doc_statuses_on_doc_profile_id"
  end

  create_table "docket_event_links", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.integer "oscn_id", null: false
    t.string "title", null: false
    t.string "link", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["docket_event_id"], name: "index_docket_event_links_on_docket_event_id"
  end

  create_table "docket_event_types", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code"], name: "index_docket_event_types_on_code", unique: true
    t.index ["id", "code"], name: "index_docket_event_types_on_id_and_code"
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
    t.boolean "is_otc_payment", default: false, null: false
    t.index ["adjustment"], name: "index_docket_events_on_adjustment", where: "(adjustment <> (0)::numeric)"
    t.index ["amount"], name: "index_docket_events_on_amount", where: "(amount <> (0)::numeric)"
    t.index ["court_case_id"], name: "index_docket_events_on_court_case_id"
    t.index ["docket_event_type_id"], name: "index_docket_events_on_docket_event_type_id"
    t.index ["party_id"], name: "index_docket_events_on_party_id"
    t.index ["payment"], name: "index_docket_events_on_payment", where: "(payment <> (0)::numeric)"
    t.index ["row_index", "court_case_id"], name: "index_docket_events_on_row_index_and_court_case_id", unique: true
  end

  create_table "event_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["oscn_id"], name: "index_event_types_on_oscn_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id"
    t.datetime "event_at", null: false
    t.string "event_name"
    t.string "docket"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "judge_id"
    t.bigint "event_type_id"
    t.index ["court_case_id"], name: "index_events_on_court_case_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["judge_id"], name: "index_events_on_judge_id"
    t.index ["party_id"], name: "index_events_on_party_id"
  end

  create_table "judges", force: :cascade do |t|
    t.string "name", null: false
    t.string "courthouse"
    t.bigint "county_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "oscn_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["county_id"], name: "index_judges_on_county_id"
  end

  create_table "ocso_warrants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.date "birth_date"
    t.string "case_number"
    t.decimal "bond_amount", precision: 14, scale: 2
    t.date "issued"
    t.string "counts"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "resolved_at"
    t.index ["case_number", "first_name", "last_name", "birth_date"], name: "index_ocso_warrants_on_case_number_etc", unique: true
  end

  create_table "okc_blotter_bookings", force: :cascade do |t|
    t.bigint "pdf_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "dob"
    t.string "sex"
    t.string "race"
    t.string "zip"
    t.boolean "transient", default: false, null: false
    t.string "inmate_number", null: false
    t.string "booking_number", null: false
    t.string "booking_type"
    t.datetime "booking_date", null: false
    t.datetime "release_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "roster_id"
    t.index ["pdf_id"], name: "index_okc_blotter_bookings_on_pdf_id"
    t.index ["roster_id"], name: "index_okc_blotter_bookings_on_roster_id"
  end

  create_table "okc_blotter_offenses", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "type", null: false
    t.decimal "bond", precision: 10, scale: 2
    t.string "code"
    t.string "dispo"
    t.string "charge", null: false
    t.string "warrant_number"
    t.string "citation_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["booking_id"], name: "index_okc_blotter_offenses_on_booking_id"
  end

  create_table "okc_blotter_pdfs", force: :cascade do |t|
    t.datetime "parsed_on"
    t.date "date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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

  create_table "parcels", force: :cascade do |t|
    t.string "geoid20", null: false
    t.string "zip"
    t.integer "tract", null: false
    t.string "block", null: false
    t.string "lat"
    t.string "long"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
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

  create_table "party_aliases", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["party_id"], name: "index_party_aliases_on_party_id"
  end

  create_table "party_htmls", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "scraped_at"
    t.text "html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["party_id"], name: "index_party_htmls_on_party_id"
  end

  create_table "party_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_party_types_on_name", unique: true
  end

  create_table "pd_bookings", force: :cascade do |t|
    t.string "jailnet_inmate_id"
    t.string "initial_docket_id"
    t.string "inmate_name"
    t.string "inmate_aka"
    t.datetime "birth_date"
    t.string "city_of_birth"
    t.string "state_of_birth"
    t.integer "current_age"
    t.string "race"
    t.string "gender"
    t.integer "height"
    t.float "weight"
    t.string "hair_color"
    t.string "eye_color"
    t.string "build"
    t.string "complexion"
    t.string "facial_hair"
    t.string "martial_status"
    t.string "emergency_contact"
    t.string "emergency_phone"
    t.string "drivers_state"
    t.string "drivers_license"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "zip_code"
    t.string "home_phone"
    t.string "fbi_nbr"
    t.string "osbi_nbr"
    t.string "tpd_nbr"
    t.integer "age_at_booking"
    t.integer "age_at_release"
    t.string "arrest_date"
    t.string "arrest_by"
    t.string "agency"
    t.string "booking_date"
    t.string "booking_by"
    t.string "otn_nbr"
    t.string "estimated_release_date"
    t.string "release_date"
    t.string "release_by"
    t.string "release_reason"
    t.string "weekend_server"
    t.string "custody_level"
    t.string "assigned_cell_id"
    t.string "current_location"
    t.string "booking_notes"
    t.string "booking_alerts"
    t.string "booking_trustees"
  end

  create_table "pd_offense_minutes", force: :cascade do |t|
    t.bigint "offense_id", null: false
    t.datetime "minute_date"
    t.string "minute"
    t.string "minute_by"
    t.string "judge"
    t.string "next_proceeding"
    t.index ["offense_id"], name: "index_pd_offense_minutes_on_offense_id"
  end

  create_table "pd_offenses", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "docket_id"
    t.integer "offense_seq"
    t.string "case_number"
    t.string "offense_code"
    t.string "offense_special_code"
    t.string "offense_description"
    t.string "offense_category"
    t.string "court"
    t.string "judge"
    t.datetime "court_date"
    t.float "bond_amount"
    t.string "bond_type"
    t.integer "jail_term"
    t.string "jail_sentence_term_type"
    t.datetime "jail_conviction_date"
    t.datetime "jail_start_date"
    t.string "form41_filed"
    t.string "docsentence_term"
    t.string "docsentence_term_type"
    t.datetime "docsentence_date"
    t.string "docnotified"
    t.string "sentence_agent"
    t.string "narative"
    t.string "disposition"
    t.datetime "disposition_date"
    t.datetime "entered_date"
    t.string "entered_by"
    t.datetime "modified_date"
    t.string "modified_by"
    t.index ["booking_id"], name: "index_pd_offenses_on_booking_id"
  end

  create_table "pleas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_pleas_on_name", unique: true
  end

  create_table "rosters", force: :cascade do |t|
    t.string "birth_year"
    t.string "birth_month"
    t.string "birth_day"
    t.string "sex"
    t.string "race"
    t.string "street_address"
    t.integer "zip"
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "titles", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tulsa_blotter_arrest_details_htmls", force: :cascade do |t|
    t.bigint "arrest_id"
    t.datetime "scraped_at", null: false
    t.text "html"
    t.index ["arrest_id"], name: "index_tulsa_blotter_arrest_details_htmls_on_arrest_id"
  end

  create_table "tulsa_blotter_arrests", force: :cascade do |t|
    t.string "dlm"
    t.string "first"
    t.string "middle"
    t.string "last"
    t.string "gender"
    t.bigint "roster_id"
    t.string "booking_id", null: false
    t.string "race"
    t.string "address"
    t.string "height"
    t.integer "weight"
    t.string "city_state_zip"
    t.string "hair"
    t.string "eyes"
    t.date "last_scraped_at"
    t.datetime "arrest_date"
    t.string "arrested_by"
    t.string "arresting_agency"
    t.datetime "booking_date"
    t.datetime "release_date"
    t.date "freedom_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["roster_id"], name: "index_tulsa_blotter_arrests_on_roster_id"
  end

  create_table "tulsa_blotter_arrests_page_htmls", force: :cascade do |t|
    t.bigint "page_html_id"
    t.bigint "arrest_id"
    t.index ["arrest_id"], name: "index_tulsa_blotter_arrests_page_htmls_on_arrest_id"
    t.index ["page_html_id"], name: "index_tulsa_blotter_arrests_page_htmls_on_page_html_id"
  end

  create_table "tulsa_blotter_offenses", force: :cascade do |t|
    t.string "description"
    t.string "case_number"
    t.string "bond_type"
    t.string "disposition"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "arrests_id"
    t.decimal "bond_amount", precision: 14, scale: 2
    t.date "court_date"
    t.index ["arrests_id"], name: "index_tulsa_blotter_offenses_on_arrests_id"
  end

  create_table "tulsa_blotter_page_htmls", force: :cascade do |t|
    t.integer "page_number", null: false
    t.datetime "scraped_at", null: false
    t.text "html"
  end

  create_table "tulsa_city_inmates", force: :cascade do |t|
    t.string "inmateId"
    t.string "firstName"
    t.string "middleName"
    t.string "lastName"
    t.string "DOB"
    t.string "height"
    t.string "weight"
    t.string "hairColor"
    t.string "eyeColor"
    t.string "race"
    t.string "gender"
    t.string "arrestDate"
    t.string "arrestingOfficer"
    t.string "arrestingAgency"
    t.string "bookingDateTime"
    t.string "courtDate"
    t.string "releasedDateTime"
    t.string "courtDivision"
    t.string "prisonerID"
    t.string "IncidentRecordID"
    t.string "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["IncidentRecordID"], name: "index_tulsa_city_inmates_on_IncidentRecordID", unique: true
    t.index ["prisonerID"], name: "index_tulsa_city_inmates_on_prisonerID", unique: true
  end

  create_table "tulsa_city_offenses", force: :cascade do |t|
    t.string "bond"
    t.string "courtDate"
    t.string "caseNumber"
    t.string "courtDivision"
    t.string "hold"
    t.string "docketId"
    t.string "title"
    t.string "section"
    t.string "paragraph"
    t.string "crime"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["docketId"], name: "index_tulsa_city_offenses_on_docketId", unique: true
  end

  create_table "verdicts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_verdicts_on_name", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "case_htmls", "court_cases"
  add_foreign_key "case_parties", "court_cases"
  add_foreign_key "case_parties", "parties"
  add_foreign_key "case_parties", "rosters"
  add_foreign_key "counsel_parties", "counsels"
  add_foreign_key "counsel_parties", "court_cases"
  add_foreign_key "counsel_parties", "parties"
  add_foreign_key "counts", "count_codes", column: "disposed_statute_code_id"
  add_foreign_key "counts", "count_codes", column: "filed_statute_code_id"
  add_foreign_key "counts", "court_cases"
  add_foreign_key "counts", "parties"
  add_foreign_key "counts", "pleas"
  add_foreign_key "counts", "verdicts"
  add_foreign_key "court_cases", "case_types"
  add_foreign_key "court_cases", "counties"
  add_foreign_key "court_cases", "judges", column: "current_judge_id"
  add_foreign_key "doc_aliases", "doc_profiles"
  add_foreign_key "doc_profiles", "doc_facilities"
  add_foreign_key "doc_profiles", "rosters"
  add_foreign_key "doc_sentences", "court_cases"
  add_foreign_key "doc_sentences", "doc_offense_codes"
  add_foreign_key "doc_sentences", "doc_profiles"
  add_foreign_key "doc_sentencing_counties", "counties"
  add_foreign_key "doc_statuses", "doc_facilities"
  add_foreign_key "doc_statuses", "doc_profiles"
  add_foreign_key "docket_event_links", "docket_events"
  add_foreign_key "docket_events", "court_cases"
  add_foreign_key "docket_events", "docket_event_types"
  add_foreign_key "docket_events", "parties"
  add_foreign_key "events", "court_cases"
  add_foreign_key "events", "event_types"
  add_foreign_key "events", "parties"
  add_foreign_key "judges", "counties"
  add_foreign_key "okc_blotter_bookings", "okc_blotter_pdfs", column: "pdf_id"
  add_foreign_key "okc_blotter_bookings", "rosters"
  add_foreign_key "okc_blotter_offenses", "okc_blotter_bookings", column: "booking_id"
  add_foreign_key "parties", "parent_parties"
  add_foreign_key "parties", "party_types"
  add_foreign_key "party_addresses", "parties"
  add_foreign_key "party_aliases", "parties"
  add_foreign_key "party_htmls", "parties"
  add_foreign_key "pd_offense_minutes", "pd_offenses", column: "offense_id"
  add_foreign_key "pd_offenses", "pd_bookings", column: "booking_id"
  add_foreign_key "tulsa_blotter_arrest_details_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests", "rosters"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_page_htmls", column: "page_html_id"
  add_foreign_key "tulsa_blotter_offenses", "tulsa_blotter_arrests", column: "arrests_id"

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
      ((( SELECT (regexp_matches(docket_events.description, '[0-9]{1,3}(?:,?[0-9]{3})*\\.[0-9]{2}'::text))[1] AS regexp_matches))::money)::numeric AS bond_amount,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RETURNED \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) AS warrant_returned_on,
          CASE
              WHEN (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) IS NULL) THEN docket_events.event_on
              ELSE (( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT ISSUED ON \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches))::date
          END AS warrant_issued_on,
      ( SELECT (regexp_matches((( SELECT regexp_matches(docket_events.description, 'WARRANT RECALLED \\d{1,2}/\\d{1,2}/\\d{4}'::text) AS regexp_matches))[1], '\\d{1,2}/\\d{1,2}/\\d{4}'::text))[1] AS regexp_matches) AS warrant_recalled_on,
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
