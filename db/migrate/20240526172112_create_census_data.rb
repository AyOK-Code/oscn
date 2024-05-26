class CreateCensusData < ActiveRecord::Migration[7.0]
  def change
    create_table :census_data do |t|
      t.references :statistic, null: false, foreign_key: { to_table: :census_statistics }
      t.integer :amount
      t.bigint  :area_id, null: false
      t.string  :area_type, null: false

      t.timestamps
    end
  end
end
