class CreateOkElectionPrecincts < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_election_precincts do |t|
      t.references :county, null: false, foreign_key: true
      t.integer :code, null: false
      t.integer :congressional_district, null: false
      t.integer :state_senate_district, null: false
      t.integer :state_house_district, null: false
      t.integer :county_commisioner, null: false
      t.string :poll_site

      t.timestamps
    end

    add_index :ok_election_precincts, :code, unique: true
  end
end
