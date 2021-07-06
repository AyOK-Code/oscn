class AddUniqueIndexToCaseParties < ActiveRecord::Migration[6.0]
  def change
    add_index :case_parties, [:party_id, :court_case_id], unique: true
  end
end
