class CreatePartyAddresses < ActiveRecord::Migration[6.0]
  def change
    create_table :party_addresses do |t|
      t.references :party, null: false, foreign_key: true
      t.datetime :record_on
      t.string :city
      t.string :state
      t.integer :zip
      t.string :address_type
      t.string :status

      t.timestamps
    end
  end
end
