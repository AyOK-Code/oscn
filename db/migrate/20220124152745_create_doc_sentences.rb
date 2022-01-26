class CreateDocSentences < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_sentences do |t|
      t.references :doc_profile, null: false, foreign_key: true
      t.references :doc_offense_code, foreign_key: true
      t.string :statute_code
      t.string :sentencing_county
      t.date :js_date
      t.string :crf_number
      t.decimal :incarcerated_term_in_years
      t.decimal :probation_term_in_years

      t.timestamps
    end
  end
end
