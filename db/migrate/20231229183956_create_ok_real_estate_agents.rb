class CreateOkRealEstateAgents < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_agents do |t|
      t.integer :license_number, null: false, index: { unique: true }
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :license_type, null: false
      t.date :license_start_on
      t.date :license_expiration_on, null: false
      t.string :other_aliases

      t.timestamps
    end
  end
end
