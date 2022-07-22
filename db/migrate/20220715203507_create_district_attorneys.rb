class CreateDistrictAttorneys < ActiveRecord::Migration[6.0]
  def change
    create_table :district_attorneys do |t|
      t.string :name, null: false
      t.integer :number, null: false

      t.timestamps
    end
  end
end
