class AddParentPartyToParties < ActiveRecord::Migration[6.1]
  def change
    add_reference :parties, :parent_party, foreign_key: true
  end
end
