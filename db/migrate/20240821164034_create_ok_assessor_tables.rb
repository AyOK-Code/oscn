class CreateOkAssessorTables < ActiveRecord::Migration[7.0]
  def change
    create_table "ok_assessor_accounts" do |t|
      t.text "account_num"
      t.bigint "parcel_num"
      t.text "account_type"
      t.integer "house_num"
      t.text "direction"
      t.text "street_name"
      t.text "street_suffix"
      t.text "unit"
      t.text "full_address"
      t.text "city"
      t.text "zipcode"
      t.text "business_name"
      t.integer "map_number"
      t.integer "buildings"
      t.text "full_legal"
      t.text "land_ecomonic_area_id"
      t.text "land_ecomonic_area_description"
      t.integer "subdivision_id"
      t.text "subdivision_description"
      t.decimal "land_total_acres"
      t.decimal "land_total_sq_foot"
      t.text "land_total_front_foot"
      t.text "land_total_units"
      t.decimal "land_width"
      t.decimal "land_depth"
      t.integer "vacant_land"
      t.text "platted_land"
      t.text "tax_district"
      t.decimal "total_mill_levy"
      t.integer "notice_of_valuation_value"
      t.integer "total_market_value"
      t.integer "total_taxable_value"
      t.integer "total_assessed_value"
      t.integer "adjusted_assessed_value"
      t.date "last_doc_date"
      t.date "last_sale_date"
      t.date "legal_change_date"
      t.date "account_created_date"
      t.date "account_deleted_date"
      t.text "status"
      t.integer "account_num_no_prefix"
      t.text "account_num_prefix"
      t.bigint "parent_parcel_num"
      t.text "subdivision_lot_number"
      t.text "subdivision_block_number"
      t.date "account_change_date"
      t.integer "adjustment_code"
      t.integer "adjustment_effective_year"

      t.index [:account_num], unique: true
    end

    create_table "ok_assessor_improvements" do |t|
      t.references :account, null: false, foreign_key: { to_table: :ok_assessor_accounts }
      t.integer "building_num"
      t.text "property_type"
      t.text "neighborhood_code"
      t.text "owner_occupied"
      t.text "occupancy_code"
      t.text "occupancy_description"
      t.text "building_type"
      t.integer "square_feet"
      t.text "condominium_square_feet"
      t.text "total_basement_square_feet"
      t.text "finished_basement_square_feet"
      t.text "garage_square_feet"
      t.text "carport_square_feet"
      t.text "balcony_square_feet"
      t.text "porch_square_feet"
      t.decimal "linear_feet_of_perimeter"
      t.integer "percent_complete"
      t.text "condition"
      t.text "quality"
      t.integer "heat_vent_air_id"
      t.text "heat_vent_air_description"
      t.text "exterior"
      t.text "interior"
      t.text "unit_type"
      t.decimal "number_of_stories"
      t.text "story_height"
      t.integer "square_feet_of_sprinkler_coverage"
      t.text "roof_type"
      t.text "roof_cover"
      t.text "floor_cover"
      t.text "foundation_type"
      t.integer "number_of_rooms"
      t.integer "number_of_bedrooms"
      t.integer "number_of_bathrooms"
      t.integer "number_of_units"
      t.text "type_of_construction_id"
      t.text "type_of_construction_description"
      t.integer "year_built"
      t.integer "year_remodeled"
      t.decimal "percent_remodeled"
      t.integer "adjusted_year_built"
      t.integer "age"
      t.text "mobilehome_title_number"
      t.text "mobilehome_serial_number"
      t.integer "mobilehome_length"
      t.integer "mobilehome_width"
      t.text "mobilehome_make"
      t.integer "improvement_value"
      t.text "new_construction_value_for_current_year"
      t.text "new_growth_value_for_current_year"
      t.integer "building_permit_value"
      t.text "status"

      t.index [:account_id, :building_num], unique: true
    end

    create_table "ok_assessor_improvement_details" do |t|
      t.references :improvement, null: false, foreign_key: { to_table: :ok_assessor_improvements }
      t.text "detail_type"
      t.text "detail_description"
      t.decimal "number_of_units"
      t.text "status"

      t.index [:improvement_id, :detail_type, :detail_description, :number_of_units], unique: true, name: :index_ok_ass_imp_details_on_imp_id_etc
    end

    create_table "ok_assessor_land_attributes" do |t|
      t.references :account, null: false, foreign_key: { to_table: :ok_assessor_accounts }
      t.text "attribute_type"
      t.text "attribute_description"
      t.decimal "attribute_adjustment"
      t.text "status"

      t.index [:account_id, :attribute_description, :attribute_type], unique: true, name: :index_ok_asse_land_attr_on_acc_id_and_attr_desc_and_attr_type
    end

    create_table "ok_assessor_owners" do |t|
      t.references :account, null: false, index: {unique: true}, foreign_key: { to_table: :ok_assessor_accounts }
      t.text "owner1"
      t.text "owner2"
      t.text "owner3"
      t.text "mailing_address1"
      t.text "mailing_address2"
      t.text "mailing_address3"
      t.text "mailing_city"
      t.text "mailing_state"
      t.text "mailing_zipcode"
      t.integer "primary_owner"
      t.text "status"
      t.date "owner_change_date"
      t.date "address_change_date"
    end

    create_table "ok_assessor_sales" do |t|
      t.references :account, null: false, foreign_key: { to_table: :ok_assessor_accounts }
      t.numeric "reception_number"
      t.text "grantor"
      t.text "grantee"
      t.integer "sale_price"
      t.date "sale_date"
      t.text "deed_type"
      t.text "valid_sale"
      t.text "confirm"
      t.integer "book"
      t.integer "page"
      t.decimal "revenue_stamps"
      t.date "change_date"

      t.index [:account_id, :reception_number], unique: true
    end

    create_table "ok_assessor_section_township_ranges" do |t|
      t.references :account, null: false, index: {unique: true}, foreign_key: { to_table: :ok_assessor_accounts }
      t.text "quarter"
      t.integer "section"
      t.text "township"
      t.text "range"
    end

    create_table "ok_assessor_value_details" do |t|
      t.references :account, null: false, foreign_key: { to_table: :ok_assessor_accounts }
      t.text "value_type"
      t.text "abstract_code"
      t.text "abstract_code_description"
      t.decimal "abstract_acres"
      t.integer "abstract_square_feet"
      t.integer "abstract_units"
      t.text "tax_district"
      t.integer "abstract_assessed_value"
      t.integer "abstract_account_value"
      t.text "status"

      t.index [:account_id, :value_type], unique: true
    end
  end
end
