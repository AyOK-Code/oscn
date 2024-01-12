class CreateOkRealEstateRegistrationRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_registration_records do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.integer :license_number
      t.string :license_category
      t.string :status
      t.date :effective_on
      t.date :initial_registration_on
      t.date :expiry_date

      t.timestamps
    end
  end
end
