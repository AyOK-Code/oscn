class CreateOkElectionVotingMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_election_voting_methods do |t|
      t.string :code, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :ok_election_voting_methods, :code, unique: true
  end
end
