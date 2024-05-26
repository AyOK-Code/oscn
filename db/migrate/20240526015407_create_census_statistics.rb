class CreateCensusStatistics < ActiveRecord::Migration[7.0]
  def change
    create_table :census_statistics do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.references :survey, null: false, foreign_key: { to_table: :census_surveys }
      t.string :concept, null: false
      t.string :group, null: false

      t.timestamps
    end
  end
end
