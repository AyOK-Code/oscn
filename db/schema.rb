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

ActiveRecord::Schema[7.0].define(version: 2023_08_30_215056) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "account_emailaddress", id: :serial, force: :cascade do |t|
    t.string "email", limit: 254, null: false
    t.boolean "verified", null: false
    t.boolean "primary", null: false
    t.integer "user_id", null: false
    t.index ["email"], name: "account_emailaddress_email_03be32b2_like", opclass: :varchar_pattern_ops
    t.index ["email"], name: "account_emailaddress_email_key", unique: true
    t.index ["user_id"], name: "account_emailaddress_user_id_2c513194"
  end

  create_table "account_emailconfirmation", id: :serial, force: :cascade do |t|
    t.timestamptz "created", null: false
    t.timestamptz "sent"
    t.string "key", limit: 64, null: false
    t.integer "email_address_id", null: false
    t.index ["email_address_id"], name: "account_emailconfirmation_email_address_id_5b7f8c58"
    t.index ["key"], name: "account_emailconfirmation_key_f43612bd_like", opclass: :varchar_pattern_ops
    t.index ["key"], name: "account_emailconfirmation_key_key", unique: true
  end

  create_table "auth_group", id: :serial, force: :cascade do |t|
    t.string "name", limit: 150, null: false
    t.index ["name"], name: "auth_group_name_a6ea08ec_like", opclass: :varchar_pattern_ops
    t.index ["name"], name: "auth_group_name_key", unique: true
  end

  create_table "auth_group_permissions", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "permission_id", null: false
    t.index ["group_id", "permission_id"], name: "auth_group_permissions_group_id_permission_id_0cd325b0_uniq", unique: true
    t.index ["group_id"], name: "auth_group_permissions_group_id_b120cbf9"
    t.index ["permission_id"], name: "auth_group_permissions_permission_id_84c5c92e"
  end

  create_table "auth_permission", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "content_type_id", null: false
    t.string "codename", limit: 100, null: false
    t.index ["content_type_id", "codename"], name: "auth_permission_content_type_id_codename_01ab375a_uniq", unique: true
    t.index ["content_type_id"], name: "auth_permission_content_type_id_2f476e4b"
  end

  create_table "auth_user", id: :serial, force: :cascade do |t|
    t.string "password", limit: 128, null: false
    t.timestamptz "last_login"
    t.boolean "is_superuser", null: false
    t.string "username", limit: 150, null: false
    t.string "first_name", limit: 150, null: false
    t.string "last_name", limit: 150, null: false
    t.string "email", limit: 254, null: false
    t.boolean "is_staff", null: false
    t.boolean "is_active", null: false
    t.timestamptz "date_joined", null: false
    t.index ["username"], name: "auth_user_username_6821ab7c_like", opclass: :varchar_pattern_ops
    t.index ["username"], name: "auth_user_username_key", unique: true
  end

  create_table "auth_user_groups", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.index ["group_id"], name: "auth_user_groups_group_id_97559544"
    t.index ["user_id", "group_id"], name: "auth_user_groups_user_id_group_id_94350c0c_uniq", unique: true
    t.index ["user_id"], name: "auth_user_groups_user_id_6a12ed8b"
  end

  create_table "auth_user_user_permissions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "permission_id", null: false
    t.index ["permission_id"], name: "auth_user_user_permissions_permission_id_1fbb5f2c"
    t.index ["user_id", "permission_id"], name: "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq", unique: true
    t.index ["user_id"], name: "auth_user_user_permissions_user_id_a95ead1b"
  end

  create_table "authtoken_token", primary_key: "key", id: { type: :string, limit: 40 }, force: :cascade do |t|
    t.timestamptz "created", null: false
    t.integer "user_id", null: false
    t.index ["key"], name: "authtoken_token_key_10f0b77e_like", opclass: :varchar_pattern_ops
    t.index ["user_id"], name: "authtoken_token_user_id_key", unique: true
  end

  create_table "case_htmls", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.datetime "scraped_at", precision: nil
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_case_id"], name: "index_case_htmls_on_court_case_id"
  end

  create_table "case_not_founds", force: :cascade do |t|
    t.bigint "county_id", null: false
    t.string "case_number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_case_not_founds_on_county_id"
  end

  create_table "case_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "counsel_parties", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id", null: false
    t.bigint "counsel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["counsel_id"], name: "index_counsel_parties_on_counsel_id"
    t.index ["court_case_id"], name: "index_counsel_parties_on_court_case_id"
    t.index ["party_id"], name: "index_counsel_parties_on_party_id"
  end

  create_table "counsels", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.integer "bar_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_count_codes_on_code", unique: true
  end

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.string "fips_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "charge"
    t.bigint "filed_statute_code_id"
    t.bigint "disposed_statute_code_id"
    t.integer "number"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "logs"
    t.bigint "current_judge_id"
    t.boolean "is_error", default: false, null: false
    t.boolean "enqueued", default: false, null: false
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((\"substring\"((case_number)::text, 3, 2))::integer <= 23) THEN ('20'::text || \"substring\"((case_number)::text, 3, 2))\n        ELSE ('19'::text || \"substring\"((case_number)::text, 3, 2))\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, 5), '^0+'::text, ''::text))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((split_part((case_number)::text, '-'::text, 2))::integer <= 23) THEN ('20'::text || split_part((case_number)::text, '-'::text, 2))\n        ELSE ('19'::text || split_part((case_number)::text, '-'::text, 2))\n    END) || '-'::text) || split_part((case_number)::text, '-'::text, 3))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (case_number)::text\n    ELSE NULL::text\nEND", stored: true
    t.index ["case_type_id"], name: "index_court_cases_on_case_type_id"
    t.index ["county_id", "oscn_id"], name: "index_court_cases_on_county_id_and_oscn_id", unique: true
    t.index ["county_id"], name: "index_court_cases_on_county_id"
    t.index ["current_judge_id"], name: "index_court_cases_on_current_judge_id"
  end

  create_table "datasources_area", force: :cascade do |t|
    t.string "identity", limit: 200, null: false
    t.jsonb "geom", null: false
    t.string "map_type", limit: 20, null: false
    t.index ["identity"], name: "datasources_area_tract_64e1493e_like", opclass: :varchar_pattern_ops
    t.index ["identity"], name: "datasources_area_tract_64e1493e_uniq", unique: true
  end

  create_table "datasources_areastatistic", force: :cascade do |t|
    t.float "value"
    t.date "date"
    t.timestamptz "created_date", null: false
    t.bigint "statistic_id", null: false
    t.string "identity_id", limit: 200, null: false
    t.index ["identity_id", "statistic_id"], name: "datasources_identit_093296_idx"
    t.index ["identity_id"], name: "datasources_areastatistic_tract_id_27b12430"
    t.index ["statistic_id"], name: "datasources_areastatistic_statistic_id_0689a96f"
  end

  create_table "datasources_datasource", force: :cascade do |t|
    t.timestamptz "date", null: false
    t.string "file", limit: 100
    t.boolean "is_parcel_linked", null: false
    t.boolean "is_average", null: false
    t.jsonb "column_list"
    t.string "map_id_column", limit: 10
    t.index ["map_id_column"], name: "datasources_datasource_map_id_column_d263390f"
    t.index ["map_id_column"], name: "datasources_datasource_map_id_column_d263390f_like", opclass: :varchar_pattern_ops
  end

  create_table "datasources_parcel", force: :cascade do |t|
    t.string "parcel_id", limit: 200, null: false
    t.string "parcel_nb", limit: 200
    t.string "geoid20", limit: 200, null: false
    t.string "zip", limit: 200, null: false
    t.string "identity_id", limit: 200
    t.string "block", limit: 200, null: false
    t.decimal "lat", precision: 17, scale: 14
    t.decimal "long", precision: 17, scale: 14
    t.index ["identity_id"], name: "datasources_parcel_tract_id_01ed29cb"
    t.index ["identity_id"], name: "datasources_parcel_tract_id_01ed29cb_like", opclass: :varchar_pattern_ops
    t.index ["parcel_nb", "geoid20", "zip", "identity_id", "block"], name: "datasources_parcel__187275_idx"
    t.index ["parcel_nb"], name: "datasources_parcel_parcel_nb_e608996f_like", opclass: :varchar_pattern_ops
    t.index ["parcel_nb"], name: "datasources_parcel_parcel_nb_e608996f_uniq", unique: true
  end

  create_table "datasources_parcelstatistic", force: :cascade do |t|
    t.float "value"
    t.date "date", null: false
    t.timestamptz "created_date", null: false
    t.string "parcel_id", limit: 200, null: false
    t.bigint "statistic_id", null: false
    t.index ["parcel_id", "statistic_id"], name: "datasources_parcel__c049c6_idx"
    t.index ["parcel_id"], name: "datasources_parcelstatistic_parcel_id_e1f79122"
    t.index ["parcel_id"], name: "datasources_parcelstatistic_parcel_id_e1f79122_like", opclass: :varchar_pattern_ops
    t.index ["statistic_id"], name: "datasources_parcelstatistic_statistic_id_0666c66c"
  end

  create_table "datasources_refresh", force: :cascade do |t|
    t.timestamptz "date", null: false
    t.bigint "source_id", null: false
    t.index ["source_id"], name: "datasources_refresh_source_id_2ce66c5e"
  end

  create_table "datasources_statistic", force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.text "description", null: false
    t.boolean "is_average", null: false
    t.bigint "statistic_category_id"
    t.boolean "published", null: false
    t.bigint "source_id"
    t.string "desired", limit: 25, null: false
    t.string "chart_zoom", limit: 25, null: false
    t.jsonb "params"
    t.bigint "parent_id"
    t.integer "rate_multiplier", null: false
    t.bigint "denominator_id"
    t.string "update_period", limit: 25, null: false
    t.timestamptz "created", null: false
    t.timestamptz "modified", null: false
    t.boolean "show_rate_on_map", null: false
    t.index ["denominator_id"], name: "datasources_statistic_denominator_id_9c807d00"
    t.index ["parent_id"], name: "datasources_statistic_parent_id_22dcfc7a"
    t.index ["source_id"], name: "datasources_statistic_source_id_54471ee0"
    t.index ["statistic_category_id"], name: "datasources_statistic_statistic_category_id_4697d786"
  end

  create_table "datasources_statistic_categories", force: :cascade do |t|
    t.bigint "statistic_id", null: false
    t.bigint "statisticcategory_id", null: false
    t.index ["statistic_id", "statisticcategory_id"], name: "datasources_statistic_ca_statistic_id_statisticca_358fb6c3_uniq", unique: true
    t.index ["statistic_id"], name: "datasources_statistic_categories_statistic_id_6bc88a81"
    t.index ["statisticcategory_id"], name: "datasources_statistic_categories_statisticcategory_id_e6f4058c"
  end

  create_table "datasources_statistic_research_questions", force: :cascade do |t|
    t.bigint "from_statistic_id", null: false
    t.bigint "to_statistic_id", null: false
    t.index ["from_statistic_id", "to_statistic_id"], name: "datasources_statistic_re_from_statistic_id_to_sta_7c3a6af8_uniq", unique: true
    t.index ["from_statistic_id"], name: "datasources_statistic_rese_from_statistic_id_9781d809"
    t.index ["to_statistic_id"], name: "datasources_statistic_rese_to_statistic_id_f4b3621d"
  end

  create_table "district_attorneys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doc_aliases", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.integer "doc_number"
    t.string "last_name"
    t.string "first_name"
    t.string "middle_name"
    t.string "suffix"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["doc_profile_id", "doc_number", "last_name", "first_name", "middle_name", "suffix"], name: "alias_index", unique: true
    t.index ["doc_profile_id"], name: "index_doc_aliases_on_doc_profile_id"
  end

  create_table "doc_facilities", force: :cascade do |t|
    t.string "name"
    t.boolean "is_prison", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "doc_historical_sentences", force: :cascade do |t|
    t.integer "external_id"
    t.bigint "doc_profile_id"
    t.string "order_id"
    t.string "charge_seq"
    t.string "crf_num"
    t.date "convict_date"
    t.string "court"
    t.string "statute_code"
    t.string "offence_description"
    t.string "offence_comment"
    t.string "sentence_term_code"
    t.string "years"
    t.string "months"
    t.string "days"
    t.string "sentence_term"
    t.date "start_date"
    t.date "end_date"
    t.string "count_num"
    t.string "order_code"
    t.string "consecutive_to_count"
    t.string "charge_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doc_profile_id"], name: "index_doc_historical_sentences_on_doc_profile_id"
  end

  create_table "doc_offense_codes", force: :cascade do |t|
    t.string "statute_code", null: false
    t.string "description", null: false
    t.boolean "is_violent", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "parent_party_id"
    t.bigint "doc_facility_id"
    t.bigint "roster_id"
    t.index ["doc_facility_id"], name: "index_doc_profiles_on_doc_facility_id"
    t.index ["doc_number"], name: "index_doc_profiles_on_doc_number", unique: true
    t.index ["parent_party_id"], name: "index_doc_profiles_on_parent_party_id"
    t.index ["roster_id"], name: "index_doc_profiles_on_roster_id"
  end

  create_table "doc_sentences", id: false, force: :cascade do |t|
    t.bigserial "id", null: false
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
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "court_case_id"
    t.string "sentence_id", null: false
    t.string "consecutive_to_sentence_id"
    t.bigint "doc_sentencing_county_id"
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((crf_number)::text ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'::text) THEN ((((\"substring\"((crf_number)::text, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}'::text) || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((crf_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((crf_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))::integer <= 40) THEN ('20'::text || \"substring\"((crf_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n            ELSE ('19'::text || \"substring\"((crf_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n        END\n        ELSE \"substring\"((crf_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((crf_number)::text, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
    t.index ["court_case_id"], name: "index_doc_sentences_on_court_case_id"
    t.index ["doc_offense_code_id"], name: "index_doc_sentences_on_doc_offense_code_id"
    t.index ["doc_profile_id", "sentence_id"], name: "index_doc_sentences_on_doc_profile_id_and_sentence_id", unique: true
    t.index ["doc_profile_id"], name: "index_doc_sentences_on_doc_profile_id"
    t.index ["doc_sentencing_county_id"], name: "index_doc_sentences_on_doc_sentencing_county_id"
    t.index ["sentence_id"], name: "index_doc_sentence_on_sentence_id"
  end

  create_table "doc_sentences_backup", id: :bigint, default: -> { "nextval('doc_sentences_id_seq'::regclass)" }, force: :cascade do |t|
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
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "court_case_id"
    t.string "sentence_id", null: false
    t.string "consecutive_to_sentence_id"
    t.bigint "doc_sentencing_county_id"
  end

  create_table "doc_sentencing_counties", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_doc_sentencing_counties_on_county_id"
  end

  create_table "doc_statuses", force: :cascade do |t|
    t.bigint "doc_profile_id", null: false
    t.string "facility", null: false
    t.date "date"
    t.string "reason"
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.bigint "doc_facility_id"
    t.index ["doc_facility_id"], name: "index_doc_statuses_on_doc_facility_id"
    t.index ["doc_profile_id", "date", "facility"], name: "status_index", unique: true
    t.index ["doc_profile_id"], name: "index_doc_statuses_on_doc_profile_id"
  end

  create_table "docket_event_links", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.integer "oscn_id", null: false
    t.string "title", null: false
    t.string "link", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docket_event_id"], name: "index_docket_event_links_on_docket_event_id"
  end

  create_table "docket_event_types", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_docket_event_types_on_code", unique: true
    t.index ["id", "code"], name: "index_docket_event_types_on_id_and_code"
  end

  create_table "docket_events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.date "event_on"
    t.bigint "docket_event_type_id", null: false
    t.text "description"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "party_id"
    t.integer "count"
    t.decimal "payment", default: "0.0"
    t.decimal "adjustment", default: "0.0"
    t.integer "row_index", null: false
    t.boolean "is_otc_payment", default: false, null: false
    t.index ["adjustment"], name: "index_docket_events_on_adjustment"
    t.index ["amount"], name: "index_docket_events_on_amount", where: "(amount <> (0)::numeric)"
    t.index ["court_case_id"], name: "index_docket_events_on_court_case_id"
    t.index ["docket_event_type_id"], name: "index_docket_events_on_docket_event_type_id"
    t.index ["party_id"], name: "index_docket_events_on_party_id"
    t.index ["payment"], name: "index_docket_events_on_payment"
    t.index ["row_index", "court_case_id"], name: "index_docket_events_on_row_index_and_court_case_id", unique: true
  end

  create_table "event_types", force: :cascade do |t|
    t.integer "oscn_id", null: false
    t.string "code", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oscn_id"], name: "index_event_types_on_oscn_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id"
    t.datetime "event_at", precision: nil, null: false
    t.string "event_name", null: false
    t.string "docket"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "judge_id"
    t.bigint "event_type_id"
    t.index ["court_case_id"], name: "index_events_on_court_case_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["judge_id"], name: "index_events_on_judge_id"
    t.index ["party_id"], name: "index_events_on_party_id"
  end

  create_table "issue_parties", force: :cascade do |t|
    t.bigint "issue_id", null: false
    t.bigint "party_id", null: false
    t.date "disposition_on"
    t.bigint "verdict_id", null: false
    t.string "verdict_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["issue_id"], name: "index_issue_parties_on_issue_id"
    t.index ["party_id"], name: "index_issue_parties_on_party_id"
    t.index ["verdict_id"], name: "index_issue_parties_on_verdict_id"
  end

  create_table "issues", force: :cascade do |t|
    t.integer "number"
    t.string "name"
    t.bigint "court_case_id", null: false
    t.bigint "count_code_id", null: false
    t.bigint "filed_by_id", null: false
    t.date "filed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["count_code_id"], name: "index_issues_on_count_code_id"
    t.index ["court_case_id"], name: "index_issues_on_court_case_id"
    t.index ["filed_by_id"], name: "index_issues_on_filed_by_id"
  end

  create_table "judges", force: :cascade do |t|
    t.string "name", null: false
    t.string "courthouse"
    t.bigint "county_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "resolved_at", precision: nil
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((\"substring\"((case_number)::text, 3, 2))::integer <= 23) THEN ('20'::text || \"substring\"((case_number)::text, 3, 2))\n        ELSE ('19'::text || \"substring\"((case_number)::text, 3, 2))\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, 5), '^0+'::text, ''::text))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN ((((\"substring\"((case_number)::text, 1, 2) || '-'::text) ||\n    CASE\n        WHEN ((split_part((case_number)::text, '-'::text, 2))::integer <= 23) THEN ('20'::text || split_part((case_number)::text, '-'::text, 2))\n        ELSE ('19'::text || split_part((case_number)::text, '-'::text, 2))\n    END) || '-'::text) || split_part((case_number)::text, '-'::text, 3))\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (case_number)::text\n    ELSE NULL::text\nEND", stored: true
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
    t.datetime "booking_date", precision: nil, null: false
    t.datetime "release_date", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_okc_blotter_offenses_on_booking_id"
  end

  create_table "okc_blotter_pdfs", force: :cascade do |t|
    t.datetime "parsed_on", precision: nil
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oklahoma_statutes", force: :cascade do |t|
    t.string "code"
    t.string "ten_digit"
    t.string "severity"
    t.text "description"
    t.date "effective_on"
    t.string "update_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parent_parties", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parties", force: :cascade do |t|
    t.integer "oscn_id"
    t.string "full_name"
    t.bigint "party_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "birth_month"
    t.integer "birth_year"
    t.string "suffix"
    t.bigint "parent_party_id"
    t.bigint "doc_profile_id"
    t.boolean "enqueued"
    t.index ["doc_profile_id"], name: "index_parties_on_doc_profile_id"
    t.index ["oscn_id"], name: "index_parties_on_oscn_id", unique: true
    t.index ["parent_party_id"], name: "index_parties_on_parent_party_id"
    t.index ["party_type_id"], name: "index_parties_on_party_type_id"
  end

  create_table "party_addresses", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "record_on", precision: nil
    t.string "city"
    t.string "state"
    t.integer "zip"
    t.string "address_type"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_addresses_on_party_id"
  end

  create_table "party_aliases", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_aliases_on_party_id"
  end

  create_table "party_htmls", force: :cascade do |t|
    t.bigint "party_id", null: false
    t.datetime "scraped_at", precision: nil
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["party_id"], name: "index_party_htmls_on_party_id"
  end

  create_table "party_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_party_types_on_name", unique: true
  end

  create_table "pleas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "titles", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tulsa_blotter_arrest_details_htmls", force: :cascade do |t|
    t.bigint "arrest_id"
    t.datetime "scraped_at", precision: nil, null: false
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
    t.datetime "arrest_date", precision: nil
    t.string "arrested_by"
    t.string "arresting_agency"
    t.datetime "booking_date", precision: nil
    t.datetime "release_date", precision: nil
    t.date "freedom_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "arrests_id"
    t.decimal "bond_amount", precision: 14, scale: 2
    t.date "court_date"
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'::text) THEN ((((\"substring\"((case_number)::text, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}'::text) || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n            ELSE ('19'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n        END\n        ELSE \"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
    t.index ["arrests_id"], name: "index_tulsa_blotter_offenses_on_arrests_id"
  end

  create_table "tulsa_blotter_page_htmls", force: :cascade do |t|
    t.integer "page_number", null: false
    t.datetime "scraped_at", precision: nil, null: false
    t.text "html"
  end

  create_table "tulsa_city_inmates", force: :cascade do |t|
    t.string "inmate_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.date "dob"
    t.string "height"
    t.string "weight"
    t.string "hair_color"
    t.string "eye_color"
    t.string "race"
    t.string "gender"
    t.datetime "arrest_date", precision: nil
    t.string "arresting_officer"
    t.string "arresting_agency"
    t.datetime "booking_date_time", precision: nil
    t.date "court_date"
    t.datetime "released_date_time", precision: nil
    t.string "court_division"
    t.string "incident_record_id"
    t.string "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["incident_record_id"], name: "index_tulsa_city_inmates_on_incident_record_id", unique: true
  end

  create_table "tulsa_city_offenses", force: :cascade do |t|
    t.bigint "inmate_id"
    t.string "bond"
    t.datetime "court_date", precision: nil
    t.string "case_number"
    t.string "court_division"
    t.string "hold"
    t.string "docket_id"
    t.string "title"
    t.string "section"
    t.string "paragraph"
    t.string "crime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'::text) THEN ((((\"substring\"((case_number)::text, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}'::text) || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n            ELSE ('19'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n        END\n        ELSE \"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
    t.index ["docket_id", "inmate_id"], name: "index_tulsa_city_offenses_on_docket_id_and_inmate_id", unique: true
    t.index ["inmate_id"], name: "index_tulsa_city_offenses_on_inmate_id"
  end

  create_table "verdicts", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_verdicts_on_name", unique: true
  end

  create_table "warrants", force: :cascade do |t|
    t.bigint "docket_event_id", null: false
    t.bigint "judge_id"
    t.integer "bond"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["docket_event_id"], name: "index_warrants_on_docket_event_id"
    t.index ["judge_id"], name: "index_warrants_on_judge_id"
  end

  add_foreign_key "doc_historical_sentences", "doc_profiles", on_update: :cascade
  add_foreign_key "doc_profiles", "parent_parties", on_update: :cascade
  add_foreign_key "doc_profiles", "rosters"
  add_foreign_key "doc_sentences", "doc_offense_codes"
  add_foreign_key "doc_sentences_backup", "doc_offense_codes", on_update: :cascade
  add_foreign_key "doc_sentences_backup", "doc_profiles", on_update: :cascade
  add_foreign_key "doc_statuses", "doc_facilities"
  add_foreign_key "docket_events", "docket_event_types", on_update: :cascade
  add_foreign_key "docket_events", "parties", on_update: :cascade
  add_foreign_key "events", "event_types", on_update: :cascade
  add_foreign_key "events", "judges", on_update: :cascade
  add_foreign_key "events", "parties", on_update: :cascade
  add_foreign_key "issue_parties", "issues"
  add_foreign_key "issue_parties", "parties"
  add_foreign_key "issue_parties", "verdicts"
  add_foreign_key "issues", "parties", column: "filed_by_id"
  add_foreign_key "okc_blotter_bookings", "okc_blotter_pdfs", column: "pdf_id"
  add_foreign_key "okc_blotter_bookings", "rosters"
  add_foreign_key "okc_blotter_offenses", "okc_blotter_bookings", column: "booking_id"
  add_foreign_key "parties", "doc_profiles", on_update: :cascade
  add_foreign_key "parties", "parent_parties"
  add_foreign_key "party_htmls", "parties", on_update: :cascade
  add_foreign_key "tulsa_blotter_arrest_details_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests", "rosters"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_page_htmls", column: "page_html_id"
  add_foreign_key "tulsa_blotter_offenses", "tulsa_blotter_arrests", column: "arrests_id"
  add_foreign_key "tulsa_city_offenses", "tulsa_city_inmates", column: "inmate_id"
  add_foreign_key "warrants", "docket_events", on_update: :cascade
  add_foreign_key "warrants", "judges", on_update: :cascade
end
