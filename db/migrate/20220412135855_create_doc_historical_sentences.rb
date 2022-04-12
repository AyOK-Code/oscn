class CreateDocHistoricalSentences < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_historical_sentences do |t|
      t.integer :external_id
      t.references :doc_profile
      t.string :order_id
      t.string :charge_seq
      t.string :crf_num
      t.date :convict_date
      t.string :court
      t.string :statute_code
      t.string :offence_description
      t.string :offence_comment
      t.string :sentence_term_code
      t.string :years
      t.string :months
      t.string :days
      t.string :sentence_term
      t.date :start_date
      t.date :end_date
      t.string :count_num
      t.string :order_code
      t.string :consecutive_to_count
      t.string :charge_status

      t.timestamps
    end
  end
end
