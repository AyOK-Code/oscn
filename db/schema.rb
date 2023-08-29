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

ActiveRecord::Schema[7.0].define(version: 2023_08_29_151652) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
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
    t.virtual "clean_case_number", type: :string, as: "\nCASE\n    WHEN ((case_number)::text ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'::text) THEN ((((\"substring\"((case_number)::text, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}'::text) || '-'::text) ||\n    CASE\n        WHEN (length(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)) = 2) THEN\n        CASE\n            WHEN ((\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))::integer <= 40) THEN ('20'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n            ELSE ('19'::text || \"substring\"((case_number)::text, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text))\n        END\n        ELSE \"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}'::text)\n    END) || '-'::text) || regexp_replace(\"substring\"((case_number)::text, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'::text), '^0+'::text, ''::text))\n    ELSE NULL::text\nEND", stored: true
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

  create_table "datasources_statistic_users", id: :bigint, default: -> { "nextval('\"datasources_statistic_Users_id_seq\"'::regclass)" }, force: :cascade do |t|
    t.bigint "statistic_id", null: false
    t.integer "user_id", null: false
    t.index ["statistic_id", "user_id"], name: "datasources_statistic_Users_statistic_id_user_id_3ea3880a_uniq", unique: true
    t.index ["statistic_id"], name: "datasources_statistic_Users_statistic_id_ddfaefdc"
    t.index ["user_id"], name: "datasources_statistic_Users_user_id_c2750f30"
  end

  create_table "datasources_statistic_visible_by", force: :cascade do |t|
    t.bigint "statistic_id", null: false
    t.integer "user_id", null: false
    t.index ["statistic_id", "user_id"], name: "datasources_statistic_vi_statistic_id_user_id_a17c5d91_uniq", unique: true
    t.index ["statistic_id"], name: "datasources_statistic_visible_by_statistic_id_8e74144b"
    t.index ["user_id"], name: "datasources_statistic_visible_by_user_id_f06a25ab"
  end

  create_table "datasources_statisticattribute", force: :cascade do |t|
    t.text "category", null: false
    t.text "value", null: false
    t.bigint "statistic_id", null: false
    t.index ["statistic_id"], name: "datasources_statisticattribute_statistic_id_dd17ea57"
  end

  create_table "datasources_statisticcategory", force: :cascade do |t|
    t.string "name", limit: 200
    t.boolean "active", null: false
    t.timestamptz "created", null: false
    t.string "fa_icon", limit: 100
    t.timestamptz "modified", null: false
    t.integer "order", limit: 2, null: false
    t.string "un_color", limit: 6
    t.string "un_name", limit: 200
    t.integer "un_sdg_number", limit: 2
    t.check_constraint "\"order\" >= 0", name: "datasources_statisticcategory_order_check"
    t.check_constraint "name IS NOT NULL OR NOT active", name: "name_required_when_active_constraint"
    t.check_constraint "un_sdg_number >= 0", name: "datasources_statisticcategory_un_sdg_number_check"
  end

  create_table "datasources_statisticrefresh", id: :bigint, default: -> { "nextval('datasources_statistic_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "field_name", limit: 200
    t.timestamptz "created_date", null: false
    t.bigint "data_source_id"
    t.boolean "imported", null: false
    t.bigint "statistic_id"
    t.date "date", null: false
    t.float "tulsa_value"
    t.float "okc_value"
    t.string "geometry", limit: 10
    t.integer "task_source_id"
    t.integer "creator_id"
    t.index ["creator_id"], name: "datasources_statisticrefresh_creator_id_986147ac"
    t.index ["data_source_id"], name: "datasources_statistic_data_source_id_40d7dc16"
    t.index ["geometry"], name: "datasources_statisticrefresh_geometry_a7d6e6c0"
    t.index ["geometry"], name: "datasources_statisticrefresh_geometry_a7d6e6c0_like", opclass: :varchar_pattern_ops
    t.index ["statistic_id"], name: "datasources_statisticrefresh_statistic_id_2cfb46c7"
    t.index ["task_source_id"], name: "datasources_statisticrefresh_task_source_id_0f2577a9"
    t.index ["task_source_id"], name: "datasources_statisticrefresh_task_source_id_0f2577a9_uniq", unique: true
    t.check_constraint "data_source_id IS NULL OR task_source_id IS NULL", name: "only_one_source_constraint"
  end

  create_table "district_attorneys", force: :cascade do |t|
    t.string "name", null: false
    t.integer "number", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "django_admin_log", id: :serial, force: :cascade do |t|
    t.timestamptz "action_time", null: false
    t.text "object_id"
    t.string "object_repr", limit: 200, null: false
    t.integer "action_flag", limit: 2, null: false
    t.text "change_message", null: false
    t.integer "content_type_id"
    t.integer "user_id", null: false
    t.index ["content_type_id"], name: "django_admin_log_content_type_id_c4bce8eb"
    t.index ["user_id"], name: "django_admin_log_user_id_c564eba6"
    t.check_constraint "action_flag >= 0", name: "django_admin_log_action_flag_check"
  end

  create_table "django_celery_beat_clockedschedule", id: :serial, force: :cascade do |t|
    t.timestamptz "clocked_time", null: false
  end

  create_table "django_celery_beat_crontabschedule", id: :serial, force: :cascade do |t|
    t.string "minute", limit: 240, null: false
    t.string "hour", limit: 96, null: false
    t.string "day_of_week", limit: 64, null: false
    t.string "day_of_month", limit: 124, null: false
    t.string "month_of_year", limit: 64, null: false
    t.string "timezone", limit: 63, null: false
  end

  create_table "django_celery_beat_intervalschedule", id: :serial, force: :cascade do |t|
    t.integer "every", null: false
    t.string "period", limit: 24, null: false
  end

  create_table "django_celery_beat_periodictask", id: :serial, force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.string "task", limit: 200, null: false
    t.text "args", null: false
    t.text "kwargs", null: false
    t.string "queue", limit: 200
    t.string "exchange", limit: 200
    t.string "routing_key", limit: 200
    t.timestamptz "expires"
    t.boolean "enabled", null: false
    t.timestamptz "last_run_at"
    t.integer "total_run_count", null: false
    t.timestamptz "date_changed", null: false
    t.text "description", null: false
    t.integer "crontab_id"
    t.integer "interval_id"
    t.integer "solar_id"
    t.boolean "one_off", null: false
    t.timestamptz "start_time"
    t.integer "priority"
    t.text "headers", null: false
    t.integer "clocked_id"
    t.integer "expire_seconds"
    t.index ["clocked_id"], name: "django_celery_beat_periodictask_clocked_id_47a69f82"
    t.index ["crontab_id"], name: "django_celery_beat_periodictask_crontab_id_d3cba168"
    t.index ["interval_id"], name: "django_celery_beat_periodictask_interval_id_a8ca27da"
    t.index ["name"], name: "django_celery_beat_periodictask_name_265a36b7_like", opclass: :varchar_pattern_ops
    t.index ["name"], name: "django_celery_beat_periodictask_name_key", unique: true
    t.index ["solar_id"], name: "django_celery_beat_periodictask_solar_id_a87ce72c"
    t.check_constraint "expire_seconds >= 0", name: "django_celery_beat_periodictask_expire_seconds_check"
    t.check_constraint "priority >= 0", name: "django_celery_beat_periodictask_priority_check"
    t.check_constraint "total_run_count >= 0", name: "django_celery_beat_periodictask_total_run_count_check"
  end

  create_table "django_celery_beat_periodictasks", primary_key: "ident", id: { type: :integer, limit: 2, default: nil }, force: :cascade do |t|
    t.timestamptz "last_update", null: false
  end

  create_table "django_celery_beat_solarschedule", id: :serial, force: :cascade do |t|
    t.string "event", limit: 24, null: false
    t.decimal "latitude", precision: 9, scale: 6, null: false
    t.decimal "longitude", precision: 9, scale: 6, null: false
    t.index ["event", "latitude", "longitude"], name: "django_celery_beat_solar_event_latitude_longitude_ba64999a_uniq", unique: true
  end

  create_table "django_celery_results_chordcounter", id: :serial, force: :cascade do |t|
    t.string "group_id", limit: 255, null: false
    t.text "sub_tasks", null: false
    t.integer "count", null: false
    t.index ["group_id"], name: "django_celery_results_chordcounter_group_id_1f70858c_like", opclass: :varchar_pattern_ops
    t.index ["group_id"], name: "django_celery_results_chordcounter_group_id_key", unique: true
    t.check_constraint "count >= 0", name: "django_celery_results_chordcounter_count_check"
  end

  create_table "django_celery_results_groupresult", id: :serial, force: :cascade do |t|
    t.string "group_id", limit: 255, null: false
    t.timestamptz "date_created", null: false
    t.timestamptz "date_done", null: false
    t.string "content_type", limit: 128, null: false
    t.string "content_encoding", limit: 64, null: false
    t.text "result"
    t.index ["date_created"], name: "django_cele_date_cr_bd6c1d_idx"
    t.index ["date_done"], name: "django_cele_date_do_caae0e_idx"
    t.index ["group_id"], name: "django_celery_results_groupresult_group_id_a085f1a9_like", opclass: :varchar_pattern_ops
    t.index ["group_id"], name: "django_celery_results_groupresult_group_id_key", unique: true
  end

  create_table "django_celery_results_taskresult", id: :serial, force: :cascade do |t|
    t.string "task_id", limit: 255, null: false
    t.string "status", limit: 50, null: false
    t.string "content_type", limit: 128, null: false
    t.string "content_encoding", limit: 64, null: false
    t.text "result"
    t.timestamptz "date_done", null: false
    t.text "traceback"
    t.text "meta"
    t.text "task_args"
    t.text "task_kwargs"
    t.string "task_name", limit: 255
    t.string "worker", limit: 100
    t.timestamptz "date_created", null: false
    t.string "periodic_task_name", limit: 255
    t.index ["date_created"], name: "django_cele_date_cr_f04a50_idx"
    t.index ["date_done"], name: "django_cele_date_do_f59aad_idx"
    t.index ["status"], name: "django_cele_status_9b6201_idx"
    t.index ["task_id"], name: "django_celery_results_taskresult_task_id_de0d95bf_like", opclass: :varchar_pattern_ops
    t.index ["task_id"], name: "django_celery_results_taskresult_task_id_key", unique: true
    t.index ["task_name"], name: "django_cele_task_na_08aec9_idx"
    t.index ["worker"], name: "django_cele_worker_d54dd8_idx"
  end

  create_table "django_content_type", id: :serial, force: :cascade do |t|
    t.string "app_label", limit: 100, null: false
    t.string "model", limit: 100, null: false
    t.index ["app_label", "model"], name: "django_content_type_app_label_model_76bd3d3b_uniq", unique: true
  end

  create_table "django_migrations", force: :cascade do |t|
    t.string "app", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.timestamptz "applied", null: false
  end

  create_table "django_session", primary_key: "session_key", id: { type: :string, limit: 40 }, force: :cascade do |t|
    t.text "session_data", null: false
    t.timestamptz "expire_date", null: false
    t.index ["expire_date"], name: "django_session_expire_date_a5c62663"
    t.index ["session_key"], name: "django_session_session_key_c0390e0f_like", opclass: :varchar_pattern_ops
  end

  create_table "django_site", id: :serial, force: :cascade do |t|
    t.string "domain", limit: 100, null: false
    t.string "name", limit: 50, null: false
    t.index ["domain"], name: "django_site_domain_a2e37b91_like", opclass: :varchar_pattern_ops
    t.index ["domain"], name: "django_site_domain_a2e37b91_uniq", unique: true
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

  create_table "doc_offense_codes", force: :cascade do |t|
    t.string "statute_code", null: false
    t.string "description", null: false
    t.boolean "is_violent", default: false, null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["oscn_id"], name: "index_event_types_on_oscn_id", unique: true
  end

  create_table "events", force: :cascade do |t|
    t.bigint "court_case_id", null: false
    t.bigint "party_id"
    t.datetime "event_at", null: false
    t.string "event_name"
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
    t.date "filed_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "filed_by"
    t.index ["count_code_id"], name: "index_issues_on_count_code_id"
    t.index ["court_case_id"], name: "index_issues_on_court_case_id"
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

  create_table "ok2_explore_deaths", force: :cascade do |t|
    t.string "last_name", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.integer "sex", null: false
    t.bigint "county_id", null: false
    t.datetime "death_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_ok2_explore_deaths_on_county_id"
  end

  create_table "ok2_explore_scrape_jobs", force: :cascade do |t|
    t.integer "year", null: false
    t.integer "month", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.boolean "is_success", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_too_many_records", default: false, null: false
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
    t.datetime "parsed_on"
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
    t.boolean "enqueued", default: false
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

  create_table "pd_bookings", force: :cascade do |t|
    t.string "jailnet_inmate_id"
    t.string "initial_docket_id"
    t.string "inmate_name"
    t.string "inmate_aka"
    t.datetime "birth_date", precision: nil
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
    t.datetime "minute_date", precision: nil
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
    t.datetime "court_date", precision: nil
    t.float "bond_amount"
    t.string "bond_type"
    t.integer "jail_term"
    t.string "jail_sentence_term_type"
    t.datetime "jail_conviction_date", precision: nil
    t.datetime "jail_start_date", precision: nil
    t.string "form41_filed"
    t.string "docsentence_term"
    t.string "docsentence_term_type"
    t.datetime "docsentence_date", precision: nil
    t.string "docnotified"
    t.string "sentence_agent"
    t.string "narative"
    t.string "disposition"
    t.datetime "disposition_date", precision: nil
    t.datetime "entered_date", precision: nil
    t.string "entered_by"
    t.datetime "modified_date", precision: nil
    t.string "modified_by"
    t.index ["booking_id"], name: "index_pd_offenses_on_booking_id"
  end

  create_table "pleas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_pleas_on_name", unique: true
  end

  create_table "projects_agecategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_disaggregationbarriers", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_educationcategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_gendercategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_healthcarecategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_incomecategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_insurancecategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_insuredstatuscategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_locationtype", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_maritalcategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_othervariables", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_parentingstatuscategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_racecategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_researcher", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_researchquestion", id: :bigint, default: -> { "nextval('projects_research_question_id_seq'::regclass)" }, force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "description", null: false
    t.timestamptz "created_date", null: false
    t.integer "author_id"
    t.text "results_report", null: false
    t.text "ableism", null: false
    t.text "accuracy", null: false
    t.text "branding", null: false
    t.text "broad_questions_to_narrow", null: false
    t.text "centered_perspectives", null: false
    t.text "change_onus", null: false
    t.text "clarity", null: false
    t.text "complexity", null: false
    t.text "copyright", null: false
    t.text "cultural_translation", null: false
    t.text "data_disaggregation_change", null: false
    t.text "data_generalization", null: false
    t.text "data_weight", null: false
    t.text "datasource_list", null: false
    t.text "define_process_answer", null: false
    t.text "depth", null: false
    t.text "digital_vs_print", null: false
    t.text "feedback", null: false
    t.text "field_list", null: false
    t.text "implicit_biases", null: false
    t.text "interactive_vs_demonstrative", null: false
    t.text "isolated_vs_network", null: false
    t.text "list_defs_of_success", null: false
    t.text "list_goals", null: false
    t.text "list_restrictions", null: false
    t.text "list_rewards", null: false
    t.text "live_vs_standalone", null: false
    t.text "narrative", null: false
    t.text "ownership", null: false
    t.text "paywall", null: false
    t.text "permanence", null: false
    t.text "perspective", null: false
    t.text "pov", null: false
    t.text "private_vs_public", null: false
    t.date "refresh_date"
    t.text "relevance", null: false
    t.date "report_date"
    t.date "request_date"
    t.text "research_sources", null: false
    t.text "sensitivity", null: false
    t.text "specificity", null: false
    t.text "static_vs_dynamic", null: false
    t.text "training", null: false
    t.boolean "BEST_partner"
    t.string "visibility", limit: 8, null: false
    t.bigint "researcher_id"
    t.string "status", limit: 12, null: false
    t.boolean "show_results_only", null: false
    t.text "requester_organization", null: false
    t.index ["author_id"], name: "projects_research_question_author_id_1ff8b07e"
    t.index ["researcher_id"], name: "projects_research_question_researcher_id_6c7bac8d"
  end

  create_table "projects_researchquestion_categories", id: :bigint, default: -> { "nextval('projects_research_question_categories_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "researchquestion_id", null: false
    t.bigint "statisticcategory_id", null: false
    t.index ["researchquestion_id", "statisticcategory_id"], name: "projects_research_questi_research_question_id_sta_3def0284_uniq", unique: true
    t.index ["researchquestion_id"], name: "projects_research_question_research_question_id_9d26b18b"
    t.index ["statisticcategory_id"], name: "projects_research_question_statisticcategory_id_f2ba72fe"
  end

  create_table "projects_researchquestion_other_variables", id: :bigint, default: -> { "nextval('projects_research_question_other_variables_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "researchquestion_id", null: false
    t.bigint "othervariables_id", null: false
    t.index ["othervariables_id"], name: "projects_research_question_othervariables_id_145a1563"
    t.index ["researchquestion_id", "othervariables_id"], name: "projects_research_questi_research_question_id_oth_56d6f715_uniq", unique: true
    t.index ["researchquestion_id"], name: "projects_research_question_research_question_id_ed02b47d"
  end

  create_table "projects_researchquestion_topics", id: :bigint, default: -> { "nextval('projects_research_question_topics_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "researchquestion_id", null: false
    t.bigint "topics_id", null: false
    t.index ["researchquestion_id", "topics_id"], name: "projects_research_questi_research_question_id_top_4816e498_uniq", unique: true
    t.index ["researchquestion_id"], name: "projects_research_question_topics_research_question_id_9be92457"
    t.index ["topics_id"], name: "projects_research_question_topics_topics_id_06d83e7d"
  end

  create_table "projects_sexcategory", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "projects_source", force: :cascade do |t|
    t.string "title", limit: 200, null: false
    t.text "description", null: false
    t.timestamptz "created_date", null: false
    t.integer "author_id"
    t.text "category_comparison", null: false
    t.text "category_define", null: false
    t.text "category_select", null: false
    t.date "collection_date"
    t.string "datasource_link", limit: 2048
    t.boolean "has_data_been_disaggregated"
    t.text "how", null: false
    t.text "quality", null: false
    t.text "refresh_frequency", null: false
    t.text "sample_pop", null: false
    t.bigint "sample_size"
    t.string "storage_link", limit: 200
    t.text "usage", null: false
    t.boolean "variable_define"
    t.date "when"
    t.text "who_collected", null: false
    t.text "who_owns", null: false
    t.text "why", null: false
    t.text "why_category", null: false
    t.bigint "where_id"
    t.bigint "why_not_disaggregated_id"
    t.string "visibility", limit: 8, null: false
    t.string "prepped_status", limit: 20, null: false
    t.index ["author_id"], name: "projects_source_author_id_2d4d785e"
    t.index ["where_id"], name: "projects_source_where_id_69a8e9a8"
    t.index ["why_not_disaggregated_id"], name: "projects_source_why_not_disaggregated_id_57358c3c"
    t.check_constraint "sample_size >= 0", name: "projects_source_sample_size_check"
  end

  create_table "projects_source_categories", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "statisticcategory_id", null: false
    t.index ["source_id", "statisticcategory_id"], name: "projects_source_categori_source_id_statisticcateg_5734b04e_uniq", unique: true
    t.index ["source_id"], name: "projects_source_categories_source_id_03c32e23"
    t.index ["statisticcategory_id"], name: "projects_source_categories_statisticcategory_id_a502f974"
  end

  create_table "projects_source_categories_age", id: :bigint, default: -> { "nextval('projects_source_category_age_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "agecategory_id", null: false
    t.index ["agecategory_id"], name: "projects_source_category_age_agecategory_id_dbb1bc6d"
    t.index ["source_id", "agecategory_id"], name: "projects_source_category_source_id_agecategory_id_e4194c8f_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_age_source_id_9a1698d6"
  end

  create_table "projects_source_categories_education", id: :bigint, default: -> { "nextval('projects_source_category_education_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "educationcategory_id", null: false
    t.index ["educationcategory_id"], name: "projects_source_category_e_educationcategory_id_ad31257d"
    t.index ["source_id", "educationcategory_id"], name: "projects_source_category_source_id_educationcateg_8d2aa595_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_education_source_id_c7ba0c4b"
  end

  create_table "projects_source_categories_gender", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "gendercategory_id", null: false
    t.index ["gendercategory_id"], name: "projects_source_categories_gender_gendercategory_id_ad55902c"
    t.index ["source_id", "gendercategory_id"], name: "projects_source_categori_source_id_gendercategory_5c3f6917_uniq", unique: true
    t.index ["source_id"], name: "projects_source_categories_gender_source_id_bf69a909"
  end

  create_table "projects_source_categories_healthcare", id: :bigint, default: -> { "nextval('projects_source_category_healthcare_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "healthcarecategory_id", null: false
    t.index ["healthcarecategory_id"], name: "projects_source_category_h_healthcarecategory_id_1ddaee9f"
    t.index ["source_id", "healthcarecategory_id"], name: "projects_source_category_source_id_healthcarecate_d17a3d8f_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_healthcare_source_id_c2053f1f"
  end

  create_table "projects_source_categories_income", id: :bigint, default: -> { "nextval('projects_source_category_income_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "incomecategory_id", null: false
    t.index ["incomecategory_id"], name: "projects_source_category_income_incomecategory_id_dfdd1285"
    t.index ["source_id", "incomecategory_id"], name: "projects_source_category_source_id_incomecategory_072bf867_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_income_source_id_d570c618"
  end

  create_table "projects_source_categories_insurance", id: :bigint, default: -> { "nextval('projects_source_category_insurance_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "insurancecategory_id", null: false
    t.index ["insurancecategory_id"], name: "projects_source_category_i_insurancecategory_id_d1538746"
    t.index ["source_id", "insurancecategory_id"], name: "projects_source_category_source_id_insurancecateg_439addb1_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_insurance_source_id_12c96c2e"
  end

  create_table "projects_source_categories_insured", id: :bigint, default: -> { "nextval('projects_source_category_insured_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "insuredstatuscategory_id", null: false
    t.index ["insuredstatuscategory_id"], name: "projects_source_category_i_insuredstatuscategory_id_db81ddeb"
    t.index ["source_id", "insuredstatuscategory_id"], name: "projects_source_category_source_id_insuredstatusc_a86b1051_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_insured_source_id_671007b5"
  end

  create_table "projects_source_categories_marital", id: :bigint, default: -> { "nextval('projects_source_category_marital_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "maritalcategory_id", null: false
    t.index ["maritalcategory_id"], name: "projects_source_category_marital_maritalcategory_id_8bcc8810"
    t.index ["source_id", "maritalcategory_id"], name: "projects_source_category_source_id_maritalcategor_b0170bed_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_marital_source_id_2e314214"
  end

  create_table "projects_source_categories_parenting", id: :bigint, default: -> { "nextval('projects_source_category_parenting_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "parentingstatuscategory_id", null: false
    t.index ["parentingstatuscategory_id"], name: "projects_source_category_p_parentingstatuscategory_id_4b7dce8d"
    t.index ["source_id", "parentingstatuscategory_id"], name: "projects_source_category_source_id_parentingstatu_1046d559_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_parenting_source_id_81338cd2"
  end

  create_table "projects_source_categories_race", id: :bigint, default: -> { "nextval('projects_source_category_race_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "racecategory_id", null: false
    t.index ["racecategory_id"], name: "projects_source_category_race_racecategory_id_c683f5b0"
    t.index ["source_id", "racecategory_id"], name: "projects_source_category_source_id_racecategory_i_ebd82b39_uniq", unique: true
    t.index ["source_id"], name: "projects_source_category_race_source_id_ac04047e"
  end

  create_table "projects_source_categories_sex", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "sexcategory_id", null: false
    t.index ["sexcategory_id"], name: "projects_source_categories_sex_sexcategory_id_7a5e6b22"
    t.index ["source_id", "sexcategory_id"], name: "projects_source_categori_source_id_sexcategory_id_bac1ec8b_uniq", unique: true
    t.index ["source_id"], name: "projects_source_categories_sex_source_id_0f19d26f"
  end

  create_table "projects_source_research_questions", id: :bigint, default: -> { "nextval('projects_source_research_question_id_seq'::regclass)" }, force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "researchquestion_id", null: false
    t.index ["researchquestion_id"], name: "projects_source_research_question_research_question_id_b8a06e2f"
    t.index ["source_id", "researchquestion_id"], name: "projects_source_research_source_id_research_quest_928025bc_uniq", unique: true
    t.index ["source_id"], name: "projects_source_research_question_source_id_451782de"
  end

  create_table "projects_source_topics_covered", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "topics_id", null: false
    t.index ["source_id", "topics_id"], name: "projects_source_topics_c_source_id_topics_id_b59edf45_uniq", unique: true
    t.index ["source_id"], name: "projects_source_topics_covered_source_id_d120fe6e"
    t.index ["topics_id"], name: "projects_source_topics_covered_topics_id_83f74664"
  end

  create_table "projects_topics", force: :cascade do |t|
    t.string "name", limit: 200, null: false
  end

  create_table "resources_category", force: :cascade do |t|
    t.string "name", limit: 200, null: false
    t.bigint "parent_category_id"
    t.text "svg_code", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["parent_category_id"], name: "resources_category_parent_category_id_6fffa3b5"
  end

  create_table "resources_resource", force: :cascade do |t|
    t.text "name", null: false
    t.string "address", limit: 200
    t.string "city", limit: 200
    t.string "state", limit: 200
    t.string "zip", limit: 200
    t.jsonb "details_html"
    t.bigint "parcel_id"
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "list_html_id"
    t.bigint "refresh_id", null: false
    t.index ["list_html_id"], name: "resources_resource_list_html_id_93af9cdb"
    t.index ["parcel_id"], name: "resources_resource_parcel_id_d8e5f681"
    t.index ["refresh_id"], name: "resources_resource_refresh_id_a263997c"
  end

  create_table "resources_resource_categories", force: :cascade do |t|
    t.bigint "resource_id", null: false
    t.bigint "category_id", null: false
    t.index ["category_id"], name: "resources_resource_categories_category_id_3944a462"
    t.index ["resource_id", "category_id"], name: "resources_resource_categ_resource_id_category_id_934a21a6_uniq", unique: true
    t.index ["resource_id"], name: "resources_resource_categories_resource_id_f2f988e9"
  end

  create_table "resources_resourcelisthtml", force: :cascade do |t|
    t.text "html", null: false
    t.timestamptz "created_at", null: false
    t.boolean "parsed", null: false
    t.jsonb "request", null: false
    t.timestamptz "updated_at", null: false
    t.bigint "refresh_id", null: false
    t.index ["refresh_id"], name: "resources_resourcelisthtml_refresh_id_f68a7098"
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

  create_table "socialaccount_socialaccount", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 30, null: false
    t.string "uid", limit: 191, null: false
    t.timestamptz "last_login", null: false
    t.timestamptz "date_joined", null: false
    t.text "extra_data", null: false
    t.integer "user_id", null: false
    t.index ["provider", "uid"], name: "socialaccount_socialaccount_provider_uid_fc810c6e_uniq", unique: true
    t.index ["user_id"], name: "socialaccount_socialaccount_user_id_8146e70c"
  end

  create_table "socialaccount_socialapp", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 30, null: false
    t.string "name", limit: 40, null: false
    t.string "client_id", limit: 191, null: false
    t.string "secret", limit: 191, null: false
    t.string "key", limit: 191, null: false
  end

  create_table "socialaccount_socialapp_sites", force: :cascade do |t|
    t.integer "socialapp_id", null: false
    t.integer "site_id", null: false
    t.index ["site_id"], name: "socialaccount_socialapp_sites_site_id_2579dee5"
    t.index ["socialapp_id", "site_id"], name: "socialaccount_socialapp__socialapp_id_site_id_71a9a768_uniq", unique: true
    t.index ["socialapp_id"], name: "socialaccount_socialapp_sites_socialapp_id_97fb6e7d"
  end

  create_table "socialaccount_socialtoken", id: :serial, force: :cascade do |t|
    t.text "token", null: false
    t.text "token_secret", null: false
    t.timestamptz "expires_at"
    t.integer "account_id", null: false
    t.integer "app_id", null: false
    t.index ["account_id"], name: "socialaccount_socialtoken_account_id_951f210e"
    t.index ["app_id", "account_id"], name: "socialaccount_socialtoken_app_id_account_id_fca4e0ac_uniq", unique: true
    t.index ["app_id"], name: "socialaccount_socialtoken_app_id_636a42d7"
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

  add_foreign_key "account_emailaddress", "auth_user", column: "user_id", name: "account_emailaddress_user_id_2c513194_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "account_emailconfirmation", "account_emailaddress", column: "email_address_id", name: "account_emailconfirm_email_address_id_5b7f8c58_fk_account_e", deferrable: :deferred
  add_foreign_key "auth_group_permissions", "auth_group", column: "group_id", name: "auth_group_permissions_group_id_b120cbf9_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_group_permissions", "auth_permission", column: "permission_id", name: "auth_group_permissio_permission_id_84c5c92e_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_permission", "django_content_type", column: "content_type_id", name: "auth_permission_content_type_id_2f476e4b_fk_django_co", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_group", column: "group_id", name: "auth_user_groups_group_id_97559544_fk_auth_group_id", deferrable: :deferred
  add_foreign_key "auth_user_groups", "auth_user", column: "user_id", name: "auth_user_groups_user_id_6a12ed8b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_permission", column: "permission_id", name: "auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm", deferrable: :deferred
  add_foreign_key "auth_user_user_permissions", "auth_user", column: "user_id", name: "auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "authtoken_token", "auth_user", column: "user_id", name: "authtoken_token_user_id_35299eff_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "case_htmls", "court_cases"
  add_foreign_key "case_not_founds", "counties"
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
  add_foreign_key "datasources_areastatistic", "datasources_area", column: "identity_id", primary_key: "identity", name: "datasources_areastat_identity_id_59216d92_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_areastatistic", "datasources_statisticrefresh", column: "statistic_id", name: "datasources_areastat_statistic_id_0689a96f_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_parcelstatistic", "datasources_parcel", column: "parcel_id", primary_key: "parcel_nb", name: "datasources_parcelst_parcel_id_e1f79122_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_parcelstatistic", "datasources_statisticrefresh", column: "statistic_id", name: "datasources_parcelst_statistic_id_0666c66c_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_refresh", "projects_source", column: "source_id", name: "datasources_refresh_source_id_2ce66c5e_fk_projects_source_id", deferrable: :deferred
  add_foreign_key "datasources_statistic", "datasources_statistic", column: "denominator_id", name: "datasources_statisti_denominator_id_9c807d00_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic", "datasources_statistic", column: "parent_id", name: "datasources_statisti_parent_id_22dcfc7a_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic", "datasources_statisticcategory", column: "statistic_category_id", name: "datasources_statisti_statistic_category_i_4697d786_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic", "projects_source", column: "source_id", name: "datasources_statistic_source_id_54471ee0_fk_projects_source_id", deferrable: :deferred
  add_foreign_key "datasources_statistic_categories", "datasources_statistic", column: "statistic_id", name: "datasources_statisti_statistic_id_6bc88a81_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic_categories", "datasources_statisticcategory", column: "statisticcategory_id", name: "datasources_statisti_statisticcategory_id_e6f4058c_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic_research_questions", "datasources_statistic", column: "from_statistic_id", name: "datasources_statisti_from_statistic_id_9781d809_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic_research_questions", "datasources_statistic", column: "to_statistic_id", name: "datasources_statisti_to_statistic_id_f4b3621d_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic_users", "auth_user", column: "user_id", name: "datasources_statistic_Users_user_id_c2750f30_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "datasources_statistic_users", "datasources_statistic", column: "statistic_id", name: "datasources_statisti_statistic_id_ddfaefdc_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statistic_visible_by", "auth_user", column: "user_id", name: "datasources_statisti_user_id_f06a25ab_fk_auth_user", deferrable: :deferred
  add_foreign_key "datasources_statistic_visible_by", "datasources_statistic", column: "statistic_id", name: "datasources_statisti_statistic_id_8e74144b_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statisticattribute", "datasources_statistic", column: "statistic_id", name: "datasources_statisti_statistic_id_dd17ea57_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statisticrefresh", "auth_user", column: "creator_id", name: "datasources_statisti_creator_id_986147ac_fk_auth_user", deferrable: :deferred
  add_foreign_key "datasources_statisticrefresh", "datasources_datasource", column: "data_source_id", name: "datasources_statisti_data_source_id_40d7dc16_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statisticrefresh", "datasources_statistic", column: "statistic_id", name: "datasources_statisti_statistic_id_2cfb46c7_fk_datasourc", deferrable: :deferred
  add_foreign_key "datasources_statisticrefresh", "django_celery_beat_periodictask", column: "task_source_id", name: "datasources_statisti_task_source_id_0f2577a9_fk_django_ce", deferrable: :deferred
  add_foreign_key "django_admin_log", "auth_user", column: "user_id", name: "django_admin_log_user_id_c564eba6_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "django_admin_log", "django_content_type", column: "content_type_id", name: "django_admin_log_content_type_id_c4bce8eb_fk_django_co", deferrable: :deferred
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_clockedschedule", column: "clocked_id", name: "django_celery_beat_p_clocked_id_47a69f82_fk_django_ce", deferrable: :deferred
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_crontabschedule", column: "crontab_id", name: "django_celery_beat_p_crontab_id_d3cba168_fk_django_ce", deferrable: :deferred
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_intervalschedule", column: "interval_id", name: "django_celery_beat_p_interval_id_a8ca27da_fk_django_ce", deferrable: :deferred
  add_foreign_key "django_celery_beat_periodictask", "django_celery_beat_solarschedule", column: "solar_id", name: "django_celery_beat_p_solar_id_a87ce72c_fk_django_ce", deferrable: :deferred
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
  add_foreign_key "issue_parties", "issues"
  add_foreign_key "issue_parties", "parties"
  add_foreign_key "issue_parties", "verdicts"
  add_foreign_key "issues", "count_codes"
  add_foreign_key "issues", "court_cases"
  add_foreign_key "judges", "counties"
  add_foreign_key "ok2_explore_deaths", "counties"
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
  add_foreign_key "projects_researchquestion", "auth_user", column: "author_id", name: "projects_research_question_author_id_1ff8b07e_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "projects_researchquestion", "projects_researcher", column: "researcher_id", name: "projects_research_qu_researcher_id_6c7bac8d_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_researchquestion_categories", "datasources_statisticcategory", column: "statisticcategory_id", name: "projects_research_qu_statisticcategory_id_f2ba72fe_fk_datasourc", deferrable: :deferred
  add_foreign_key "projects_researchquestion_categories", "projects_researchquestion", column: "researchquestion_id", name: "projects_researchque_researchquestion_id_ea254582_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_researchquestion_other_variables", "projects_othervariables", column: "othervariables_id", name: "projects_research_qu_othervariables_id_145a1563_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_researchquestion_other_variables", "projects_researchquestion", column: "researchquestion_id", name: "projects_researchque_researchquestion_id_f57381e5_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_researchquestion_topics", "projects_researchquestion", column: "researchquestion_id", name: "projects_researchque_researchquestion_id_dda5957e_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_researchquestion_topics", "projects_topics", column: "topics_id", name: "projects_research_qu_topics_id_06d83e7d_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source", "auth_user", column: "author_id", name: "projects_source_author_id_2d4d785e_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "projects_source", "projects_disaggregationbarriers", column: "why_not_disaggregated_id", name: "projects_source_why_not_disaggregate_57358c3c_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source", "projects_locationtype", column: "where_id", name: "projects_source_where_id_69a8e9a8_fk_projects_locationtype_id", deferrable: :deferred
  add_foreign_key "projects_source_categories", "datasources_statisticcategory", column: "statisticcategory_id", name: "projects_source_cate_statisticcategory_id_a502f974_fk_datasourc", deferrable: :deferred
  add_foreign_key "projects_source_categories", "projects_source", column: "source_id", name: "projects_source_cate_source_id_03c32e23_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_age", "projects_agecategory", column: "agecategory_id", name: "projects_source_cate_agecategory_id_dbb1bc6d_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_age", "projects_source", column: "source_id", name: "projects_source_cate_source_id_9a1698d6_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_education", "projects_educationcategory", column: "educationcategory_id", name: "projects_source_cate_educationcategory_id_ad31257d_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_education", "projects_source", column: "source_id", name: "projects_source_cate_source_id_c7ba0c4b_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_gender", "projects_gendercategory", column: "gendercategory_id", name: "projects_source_cate_gendercategory_id_ad55902c_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_gender", "projects_source", column: "source_id", name: "projects_source_cate_source_id_bf69a909_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_healthcare", "projects_healthcarecategory", column: "healthcarecategory_id", name: "projects_source_cate_healthcarecategory_i_1ddaee9f_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_healthcare", "projects_source", column: "source_id", name: "projects_source_cate_source_id_c2053f1f_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_income", "projects_incomecategory", column: "incomecategory_id", name: "projects_source_cate_incomecategory_id_dfdd1285_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_income", "projects_source", column: "source_id", name: "projects_source_cate_source_id_d570c618_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_insurance", "projects_insurancecategory", column: "insurancecategory_id", name: "projects_source_cate_insurancecategory_id_d1538746_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_insurance", "projects_source", column: "source_id", name: "projects_source_cate_source_id_12c96c2e_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_insured", "projects_insuredstatuscategory", column: "insuredstatuscategory_id", name: "projects_source_cate_insuredstatuscategor_db81ddeb_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_insured", "projects_source", column: "source_id", name: "projects_source_cate_source_id_671007b5_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_marital", "projects_maritalcategory", column: "maritalcategory_id", name: "projects_source_cate_maritalcategory_id_8bcc8810_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_marital", "projects_source", column: "source_id", name: "projects_source_cate_source_id_2e314214_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_parenting", "projects_parentingstatuscategory", column: "parentingstatuscategory_id", name: "projects_source_cate_parentingstatuscateg_4b7dce8d_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_parenting", "projects_source", column: "source_id", name: "projects_source_cate_source_id_81338cd2_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_race", "projects_racecategory", column: "racecategory_id", name: "projects_source_cate_racecategory_id_c683f5b0_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_race", "projects_source", column: "source_id", name: "projects_source_cate_source_id_ac04047e_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_sex", "projects_sexcategory", column: "sexcategory_id", name: "projects_source_cate_sexcategory_id_7a5e6b22_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_categories_sex", "projects_source", column: "source_id", name: "projects_source_cate_source_id_0f19d26f_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_research_questions", "projects_researchquestion", column: "researchquestion_id", name: "projects_source_rese_researchquestion_id_aa32edb1_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_research_questions", "projects_source", column: "source_id", name: "projects_source_rese_source_id_451782de_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_topics_covered", "projects_source", column: "source_id", name: "projects_source_topi_source_id_d120fe6e_fk_projects_", deferrable: :deferred
  add_foreign_key "projects_source_topics_covered", "projects_topics", column: "topics_id", name: "projects_source_topi_topics_id_83f74664_fk_projects_", deferrable: :deferred
  add_foreign_key "resources_category", "resources_category", column: "parent_category_id", name: "resources_category_parent_category_id_6fffa3b5_fk_resources", deferrable: :deferred
  add_foreign_key "resources_resource", "datasources_parcel", column: "parcel_id", name: "resources_resource_parcel_id_d8e5f681_fk_datasources_parcel_id", deferrable: :deferred
  add_foreign_key "resources_resource", "datasources_refresh", column: "refresh_id", name: "resources_resource_refresh_id_a263997c_fk_datasourc", deferrable: :deferred
  add_foreign_key "resources_resource", "resources_resourcelisthtml", column: "list_html_id", name: "resources_resource_list_html_id_93af9cdb_fk_resources", deferrable: :deferred
  add_foreign_key "resources_resource_categories", "resources_category", column: "category_id", name: "resources_resource_c_category_id_3944a462_fk_resources", deferrable: :deferred
  add_foreign_key "resources_resource_categories", "resources_resource", column: "resource_id", name: "resources_resource_c_resource_id_f2f988e9_fk_resources", deferrable: :deferred
  add_foreign_key "resources_resourcelisthtml", "datasources_refresh", column: "refresh_id", name: "resources_resourceli_refresh_id_f68a7098_fk_datasourc", deferrable: :deferred
  add_foreign_key "socialaccount_socialaccount", "auth_user", column: "user_id", name: "socialaccount_socialaccount_user_id_8146e70c_fk_auth_user_id", deferrable: :deferred
  add_foreign_key "socialaccount_socialapp_sites", "django_site", column: "site_id", name: "socialaccount_social_site_id_2579dee5_fk_django_si", deferrable: :deferred
  add_foreign_key "socialaccount_socialapp_sites", "socialaccount_socialapp", column: "socialapp_id", name: "socialaccount_social_socialapp_id_97fb6e7d_fk_socialacc", deferrable: :deferred
  add_foreign_key "socialaccount_socialtoken", "socialaccount_socialaccount", column: "account_id", name: "socialaccount_social_account_id_951f210e_fk_socialacc", deferrable: :deferred
  add_foreign_key "socialaccount_socialtoken", "socialaccount_socialapp", column: "app_id", name: "socialaccount_social_app_id_636a42d7_fk_socialacc", deferrable: :deferred
  add_foreign_key "tulsa_blotter_arrest_details_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests", "rosters"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_arrests", column: "arrest_id"
  add_foreign_key "tulsa_blotter_arrests_page_htmls", "tulsa_blotter_page_htmls", column: "page_html_id"
  add_foreign_key "tulsa_blotter_offenses", "tulsa_blotter_arrests", column: "arrests_id"
  add_foreign_key "tulsa_city_offenses", "tulsa_city_inmates", column: "inmate_id"

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
      court_cases.county_id,
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

  create_view "report_arresting_agencies", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.county_id,
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

  create_view "report_fines_and_fees", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.id AS court_case_id,
      court_cases.county_id,
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

  create_view "report_searchable_cases", materialized: true, sql_definition: <<-SQL
      SELECT court_cases.case_number,
      court_cases.filed_on,
      court_cases.county_id,
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

  create_view "report_ocso_oscn_joins", sql_definition: <<-SQL
      WITH clean_ocso AS (
           SELECT ocso_warrants.id AS ocso_id,
              ocso_warrants.first_name AS ocso_first_name,
              ocso_warrants.last_name AS ocso_last_name,
              ocso_warrants.middle_name AS ocso_middle_name,
              ocso_warrants.birth_date AS ocso_birth_date,
              ocso_warrants.bond_amount AS ocso_bond_amount,
              ocso_warrants.issued AS ocso_issued,
              ocso_warrants.counts AS ocso_counts,
              ocso_warrants.resolved_at AS ocso_resolved_at,
              ocso_warrants.case_number AS ocso_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN "substring"((ocso_warrants.case_number)::text, 1, 2)
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN "substring"((ocso_warrants.case_number)::text, '[A-Za-z]{1,}'::text)
                      ELSE NULL::text
                  END AS case_type,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN (
                      CASE
                          WHEN (("substring"((ocso_warrants.case_number)::text, 3, 2))::integer <= 23) THEN ('20'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                          ELSE ('19'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                      END)::integer
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN (
                      CASE
                          WHEN ((split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer <= 23) THEN ('20'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                          ELSE ('19'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                      END)::integer
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer
                      ELSE NULL::integer
                  END AS full_year,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text)
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN split_part((ocso_warrants.case_number)::text, '-'::text, 3)
                      ELSE NULL::text
                  END AS last_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN (((("substring"((ocso_warrants.case_number)::text, 1, 2) || '-'::text) ||
                      CASE
                          WHEN (("substring"((ocso_warrants.case_number)::text, 3, 2))::integer <= 23) THEN ('20'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                          ELSE ('19'::text || "substring"((ocso_warrants.case_number)::text, 3, 2))
                      END) || '-'::text) || regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}'::text) THEN (((("substring"((ocso_warrants.case_number)::text, 1, 2) || '-'::text) ||
                      CASE
                          WHEN ((split_part((ocso_warrants.case_number)::text, '-'::text, 2))::integer <= 23) THEN ('20'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                          ELSE ('19'::text || split_part((ocso_warrants.case_number)::text, '-'::text, 2))
                      END) || '-'::text) || split_part((ocso_warrants.case_number)::text, '-'::text, 3))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}'::text) THEN (ocso_warrants.case_number)::text
                      ELSE NULL::text
                  END AS clean_case_number,
                  CASE
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}[0-9]{5,}'::text) THEN ((((('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || "substring"((ocso_warrants.case_number)::text, 1, 2)) || '-'::text) || "substring"((ocso_warrants.case_number)::text, 3, 2)) || '-'::text) || regexp_replace("substring"((ocso_warrants.case_number)::text, 5), '^0+'::text, ''::text))
                      WHEN ((ocso_warrants.case_number)::text ~ '^[A-Za-z]{2}-[0-9]{2,}-[0-9]{1,}'::text) THEN ('https://www.oscn.net/dockets/GetCaseInformation.aspx?db=oklahoma&number='::text || (ocso_warrants.case_number)::text)
                      ELSE NULL::text
                  END AS link
             FROM ocso_warrants
          ), added_defendant_counts AS (
           SELECT clean_ocso.ocso_id,
              clean_ocso.ocso_first_name,
              clean_ocso.ocso_last_name,
              clean_ocso.ocso_middle_name,
              clean_ocso.ocso_birth_date,
              clean_ocso.ocso_bond_amount,
              clean_ocso.ocso_issued,
              clean_ocso.ocso_counts,
              clean_ocso.ocso_resolved_at,
              clean_ocso.ocso_case_number,
              clean_ocso.case_type,
              clean_ocso.full_year,
              clean_ocso.last_case_number,
              clean_ocso.clean_case_number,
              clean_ocso.link,
              ( SELECT count(DISTINCT parties.id) AS count
                     FROM ((((case_parties
                       JOIN parties ON ((case_parties.party_id = parties.id)))
                       JOIN court_cases ON ((court_cases.id = case_parties.court_case_id)))
                       JOIN counties ON ((court_cases.county_id = counties.id)))
                       JOIN party_types ON ((parties.party_type_id = party_types.id)))
                    WHERE (((party_types.name)::text = 'defendant'::text) AND ((court_cases.case_number)::text = clean_ocso.clean_case_number) AND ((counties.name)::text = 'Oklahoma'::text))) AS defendant_count
             FROM clean_ocso
            WHERE (clean_ocso.ocso_resolved_at IS NULL)
          )
   SELECT added_defendant_counts.ocso_id,
      added_defendant_counts.ocso_first_name,
      added_defendant_counts.ocso_last_name,
      added_defendant_counts.ocso_middle_name,
      added_defendant_counts.ocso_birth_date,
      added_defendant_counts.ocso_bond_amount,
      added_defendant_counts.ocso_issued,
      added_defendant_counts.ocso_counts,
      added_defendant_counts.ocso_resolved_at,
      added_defendant_counts.ocso_case_number,
      added_defendant_counts.case_type,
      added_defendant_counts.full_year,
      added_defendant_counts.last_case_number,
      added_defendant_counts.clean_case_number,
      added_defendant_counts.link,
      added_defendant_counts.defendant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::bigint
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT count(*) AS count
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1)))
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT count(*) AS count
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2))))
              ELSE NULL::bigint
          END AS warrant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::bigint
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT count(*) AS count
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['RETBW'::character varying, 'RETWA'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1)))
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT count(*) AS count
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['RETBW'::character varying, 'RETWA'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2))))
              ELSE NULL::bigint
          END AS return_warrant_count,
          CASE
              WHEN (added_defendant_counts.defendant_count = 0) THEN NULL::character varying
              WHEN (added_defendant_counts.defendant_count = 1) THEN ( SELECT docket_event_types.code
                 FROM (((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND (( SELECT count(DISTINCT parties.id) AS count
                         FROM ((case_parties
                           JOIN parties ON ((case_parties.party_id = parties.id)))
                           JOIN party_types ON ((parties.party_type_id = party_types.id)))
                        WHERE (((party_types.name)::text = 'defendant'::text) AND (case_parties.court_case_id = court_cases.id))) = 1))
                ORDER BY docket_events.event_on DESC
               LIMIT 1)
              WHEN (added_defendant_counts.defendant_count > 1) THEN ( SELECT docket_event_types.code
                 FROM ((((docket_events
                   JOIN court_cases ON ((docket_events.court_case_id = court_cases.id)))
                   JOIN counties ON ((court_cases.county_id = counties.id)))
                   JOIN parties ON ((docket_events.party_id = parties.id)))
                   JOIN docket_event_types ON ((docket_events.docket_event_type_id = docket_event_types.id)))
                WHERE (((docket_event_types.code)::text = ANY ((ARRAY['BWIFP'::character varying, 'WAIMW'::character varying, 'BWIFAP'::character varying, 'BWIFC'::character varying, 'BWIR8'::character varying, 'BWIAR'::character varying, 'BWICA'::character varying, 'BWIFA'::character varying, 'BWIFAA'::character varying, 'BWIS$'::character varying, 'BWIFAR'::character varying, 'BWIAA'::character varying, 'BWIMW'::character varying, 'WAI$'::character varying, 'WAI'::character varying, 'BWIS'::character varying])::text[])) AND ((counties.name)::text = 'Oklahoma'::text) AND ((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((levenshtein(lower((parties.first_name)::text), lower((added_defendant_counts.ocso_first_name)::text)) <= 2) OR (levenshtein(lower((parties.last_name)::text), lower((added_defendant_counts.ocso_last_name)::text)) <= 2)))
                ORDER BY docket_events.event_on DESC
               LIMIT 1)
              ELSE NULL::character varying
          END AS most_recent_warrant_type,
      ( SELECT case_htmls.scraped_at
             FROM ((court_cases
               JOIN counties ON ((court_cases.county_id = counties.id)))
               JOIN case_htmls ON ((case_htmls.court_case_id = court_cases.id)))
            WHERE (((court_cases.case_number)::text = added_defendant_counts.clean_case_number) AND ((counties.name)::text = 'Oklahoma'::text))
           LIMIT 1) AS scraped_at
     FROM added_defendant_counts;
  SQL
end
