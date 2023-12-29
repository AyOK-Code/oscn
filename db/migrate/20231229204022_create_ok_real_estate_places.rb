class CreateOkRealEstatePlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_places do |t|
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.string :name
      t.string :branch_office
      t.string :street
      t.string :city
      t.string :state
      t.string :phone_number

      t.timestamps
    end
  end
end
