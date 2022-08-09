class RenamingDocSentencingCountyId < ActiveRecord::Migration[6.0]
  def change
    rename_column :doc_sentences, :doc_sentencing_county_id_id, :doc_sentencing_county_id
    change_column_null(:doc_sentencing_counties, :county_id, true)

  end
end
