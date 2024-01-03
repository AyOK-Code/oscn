class CreateOkRealEstatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_places do |t|
      t.string :external_id, null: false, index: { unique: true }
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.date :start_date
      t.date :end_date
      t.boolean :primary, null: false, default: false
      t.string :registrant
      t.string :phone
      t.string :position
      t.string :email
      t.boolean :active, null: false, default: false
      t.string :employer_name
      t.string :business_address
      t.string :business_city
      t.string :business_state
      t.string :business_zip_code
      t.string :organization
      t.boolean :is_branch_office, null: false, default: false

      t.timestamps
    end
  end
end
