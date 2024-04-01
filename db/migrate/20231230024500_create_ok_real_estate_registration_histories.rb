class CreateOkRealEstateRegistrationHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_registration_histories do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.string :license_category
      t.string :status
      t.date :effective_on

      t.timestamps
    end
  end
end
