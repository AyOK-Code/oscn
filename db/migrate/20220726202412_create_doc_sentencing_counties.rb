class CreateDocSentencingCounties < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_sentencing_counties do |t|
      t.string :name, null: false
      t.references :county, null: false, foreign_key: true

      t.timestamps
    end
    add_reference :doc_sentences, :doc_sentencing_county_id, index: true, null: true
  end
end
