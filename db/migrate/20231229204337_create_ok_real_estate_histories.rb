class CreateOkRealEstateHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_histories do |t|
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.string :license_type
      t.string :license_status
      t.date :license_effective_on

      t.timestamps
    end
  end
end
