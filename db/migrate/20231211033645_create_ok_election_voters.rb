class CreateOkElectionVoters < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_election_voters do |t|
      t.references :precinct, null: false, foreign_key: { to_table: :ok_election_precincts }
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.integer :voter_id, null: false
      t.integer :political_affiliation, null: false
      t.integer :status, null: false
      t.string :street_number
      t.string :street_direction
      t.string :street_name
      t.string :street_type
      t.string :building_number
      t.string :city
      t.string :zip_code
      t.datetime :date_of_birth
      t.datetime :original_registration

      t.timestamps
    end

    add_index :ok_election_voters, :voter_id, unique: true
  end
end
