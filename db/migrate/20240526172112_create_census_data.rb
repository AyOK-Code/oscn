class CreateCensusData < ActiveRecord::Migration[7.0]
  def change
    create_table :census_data do |t|
      t.references :statistic, null: false, foreign_key: { to_table: :census_statistics }
      t.string :amount
      t.references :area,   null: false, polymorphic: true

      t.timestamps
    end
  end
end
