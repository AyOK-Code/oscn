class CreateOkElectionVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_election_votes do |t|
      t.references :voter, null: false, foreign_key: { to_table: :ok_election_voters }
      t.datetime :election_on
      t.references :voting_method, null: false, foreign_key: { to_table: :ok_election_voting_methods }

      t.timestamps
    end
  end
end
