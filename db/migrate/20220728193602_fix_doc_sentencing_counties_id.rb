class FixDocSentencingCountiesId < ActiveRecord::Migration[6.0]
  def change
    rename_column :doc_sentences, :doc_sentencing_counties_id, :doc_sentencing_county_id

  end
end
