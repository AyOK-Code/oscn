class CreatePartyAliases < ActiveRecord::Migration[6.0]
  def change
    create_table :party_aliases do |t|
      t.references :party, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
