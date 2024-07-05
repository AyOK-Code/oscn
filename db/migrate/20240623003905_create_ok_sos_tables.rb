class CreateOkSosTables < ActiveRecord::Migration[7.0]
  def change
    create_table "ok_sos_audit_logs" do |t|
      t.string "reference_number", null: false
      t.datetime "audit_date"
      t.integer "table_id"
      t.integer "field_id"
      t.string "previous_value"
      t.string "current_value"
      t.string "action"
      t.string "audit_comment"

      t.timestamps

      t.index [:reference_number, :audit_date, :table_id, :field_id, :previous_value, :current_value, :action],
              unique: true,
              name: :index_sos_audit_logs_cols
    end

    create_table "ok_sos_capacities" do |t|
      t.integer "capacity_id", null: false, index: { unique: true }
      t.string "description"

      t.timestamps
    end

    create_table "ok_sos_corp_statuses" do |t|
      t.integer "status_id", null: false, index: { unique: true }
      t.string "status_description"

      t.timestamps
    end

    create_table "ok_sos_corp_types" do |t|
      t.integer "corp_type_id", null: false, index: { unique: true }
      t.string "corp_type_description"

      t.timestamps
    end

    create_table "ok_sos_filing_types" do |t|
      t.integer "filing_type_id", null: false, index: { unique: true }
      t.string "filing_type"

      t.timestamps
    end

    create_table "ok_sos_entity_addresses" do |t|
      t.bigint "address_id", null: false, index: { unique: true }
      t.string "address1"
      t.string "address2"
      t.string "city" # todo: should this be on the zip table?
      t.string "state" # todo: should this be on the zip table?
      t.string "zip_string" # todo: not sure if we need
      t.integer "zip_extension"
      t.string "country"

      t.references "zip_code", name: "zip_codes"

      t.timestamps
    end

    create_table "ok_sos_name_statuses" do |t|
      t.integer "name_status_id", null: false, index: { unique: true }
      t.string "name_status"

      t.timestamps
    end

    create_table "ok_sos_name_types" do |t|
      t.integer "name_type_id", null: false, index: { unique: true }
      t.string "name_type"

      t.timestamps
    end

    create_table "ok_sos_suffixes" do |t|
      t.integer "suffix_id", null: false, index: { unique: true }
      t.string "suffix"

      t.timestamps
    end

    create_table "ok_sos_stock_types" do |t|
      t.integer "stock_type_id", null: false, index: { unique: true }
      t.string "stock_type_description"

      t.timestamps
    end


    create_table "ok_sos_entities" do |t|
      t.bigint "filing_number", null: false, index: { unique: true }
      t.bigint "status_id"
      t.bigint "external_corp_type_id", null: false # prefixed!!
      t.bigint "external_address_id" # prefixed!!
      t.string "name"
      t.integer "perpetual_flag"
      t.datetime "creation_date"
      t.datetime "expiration_date"
      t.datetime "inactive_date"
      t.datetime "formation_date"
      t.datetime "report_due_date"
      t.integer "tax_id"
      t.string "fictitious_name"
      t.datetime "foreign_fein"
      t.string "foreign_state"
      t.string "foreign_country"
      t.datetime "foreign_formation_date"
      t.string "expiration_type"
      t.datetime "last_report_filed_date"
      t.string "telno"
      t.integer "otc_suspension_flag"
      t.string "consent_name_flag"

      t.references "corp_type", null: false, to_table: "ok_sos_corp_types"
      t.references "entity_address", to_table: "ok_sos_entity_addresses"

      t.timestamps
    end

    create_table "ok_sos_corp_filings" do |t|
      t.bigint "filing_number" # new?
      t.bigint "document_number"
      t.bigint "external_filing_type_id"
      t.string "external_filing_type"
      t.datetime "entry_date"
      t.datetime "filing_date"
      t.datetime "effective_date"
      t.integer "effective_cond_flag" # abbreviated to match
      t.datetime "inactive_date"

      t.index [:filing_number, :document_number], unique: true

      t.references :filing_type, foreign_key: { to_table: :ok_sos_filing_types }
      t.references :entity, foreign_key: { to_table: :ok_sos_entities }

      t.timestamps
    end

    create_table "ok_sos_names" do |t|
      t.bigint "filing_number" # new?
      t.bigint "name_id", null: false
      t.string "name"
      t.bigint "external_name_status_id" # prefixed
      t.bigint "external_name_type_id" # prefixed
      t.datetime "creation_date"
      t.datetime "inactive_date"
      t.datetime "expire_date"
      t.string "all_counties_flag"
      t.bigint "consent_filing_number"
      t.bigint "search_id"
      t.string "transfer_to"
      t.string "received_from"

      t.index [:filing_number, :name_id], unique: true

      t.references "name_type", to_table: "ok_sos_name_types"
      t.references "name_status", to_table: "ok_sos_name_status"
      t.references "entity", to_table: "ok_sos_entities" #todo: this seems like should be required

      t.timestamps
    end

    create_table "ok_sos_stock_data" do |t|
      t.integer "stock_id", null: false
      t.bigint "filing_number" # new?
      t.integer "external_stock_type_id", null: false # prefix?
      t.integer "stock_series"
      t.float "share_volume"
      t.float "par_value"

      t.index [:filing_number, :stock_id], unique: true

      t.references "entity", to_table: "ok_sos_entities"
      t.references "stock_type", null: false, to_table: "ok_sos_stock_types"

      t.timestamps
    end

    create_table "ok_sos_stock_infos" do |t|
      t.bigint "filing_number", null: false, index: { unique: true }
      t.integer "qualify_flag"
      t.integer "unlimited_flag"
      t.float "actual_amount_invested"
      t.float "pd_on_credit"
      t.float "tot_auth_capital"

      t.references "entity", to_table: "ok_sos_entities" # required?

      t.timestamps
    end

    create_table "ok_sos_agents" do |t|
      t.bigint "filing_number", null: false, index: { unique: true }
      t.bigint "external_address_id" # ?
      t.string "business_name"
      t.string "agent_last_name"
      t.string "agent_first_name"
      t.string "agent_middle_name"
      t.string "agent_suffix_id" # ?
      t.datetime "creation_date"
      t.datetime "inactive_date"
      t.string "normalized_name"
      t.integer "sos_ra_flag"

      t.references :suffix, foreign_key: { to_table: :ok_sos_suffixes }
      t.references :entity_address, foreign_key: { to_table: :ok_sos_entity_addresses }
      t.references :entity, foreign_key: { to_table: :ok_sos_entities }

      t.timestamps
    end

    create_table "ok_sos_associated_entities" do |t|
      t.bigint "filing_number" # new?
      t.bigint "document_number"
      t.bigint "associated_entity_id"
      t.bigint "associated_entity_corp_type_id"
      t.bigint "primary_capacity_id"
      t.bigint "external_capacity_id" # prefix?
      t.string "associated_entity_name"
      t.bigint "entity_filing_number"
      t.datetime "entity_filing_date"
      t.datetime "inactive_date"
      t.string "jurisdiction_state"
      t.string "jurisdiction_country"

      t.index [:filing_number, :associated_entity_id], unique: true, name: :index_ok_sos_ass_entities_on_filing_number_and_ass_entity_id

      t.references :capacity, null: false, foreign_key: { to_table: :ok_sos_capacities }
      t.references :corp_type, foreign_key: { to_table: :ok_sos_corp_types }
      t.references :entity, foreign_key: { to_table: :ok_sos_entities }

      t.timestamps
    end

    create_table "ok_sos_officers" do |t|
      t.bigint "filing_number" # new?
      t.integer "officer_id", null: false
      t.string "officer_title"
      t.string "business_name"
      t.string "last_name" # unprefix?
      t.string "first_name" # unprefix?
      t.string "middle_name" # unprefix?
      t.bigint "external_suffix_id" # prefix?
      t.bigint "external_address_id" # prefix?
      t.datetime "creation_date"
      t.datetime "inactive_date"
      t.datetime "last_modified_date"
      t.string "normalized_name"

      t.index [:filing_number, :officer_id], unique: true

      t.references "entity_address", to_table: "ok_sos_entity_addresses"
      t.references "entity", to_table: "ok_sos_entities"
      t.references "suffix", to_table: "ok_sos_suffixes"

      t.timestamps
    end
  end
end
