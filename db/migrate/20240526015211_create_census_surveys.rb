class CreateCensusSurveys < ActiveRecord::Migration[7.0]
  def change
    create_table :census_surveys do |t|
      t.string :name, null: false
      t.integer :year, null: false

      t.timestamps
    end
  end
end
