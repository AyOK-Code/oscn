class CreateOkRealEstateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_agents do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name
      t.string :middle_name
      t.string :other_name
      t.integer :license_number, null: false
      t.string :license_category, null: false
      t.string :license_status, null: false
      t.date :initial_license_on
      t.date :license_expiration_on
      t.boolean :has_public_notices, null: false
      t.datetime :scraped_on

      t.timestamps
    end
  end
end
