class CreateOk2ExploreDeaths < ActiveRecord::Migration[7.0]
  def change
    create_table :ok2_explore_deaths do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.integer :sex
      t.references :county, null: false, foreign_key: true
      t.datetime :death_on

      t.timestamps
    end
  end
end
