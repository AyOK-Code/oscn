class CreatePartyHtmls < ActiveRecord::Migration[6.0]
  def change
    create_table :party_htmls do |t|
      t.references :party, null: false, foreign_key: true
      t.datetime :scraped_at
      t.text :html

      t.timestamps
    end
  end
end
