class AddCleanCaseNumberToDocSentences < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      ALTER TABLE doc_sentences
      ADD COLUMN clean_case_number VARCHAR GENERATED ALWAYS AS (
        CASE 
          WHEN crf_number ~ 'CF-\\d{4}-[0-9]{1,4}' THEN crf_number
          WHEN crf_number ~ '\\d{4}-[0-9]{1,4}' THEN 'CF-' || crf_number
          WHEN crf_number ~ '\\d{2}-[0-9]{1,4}' THEN 'CF-20' || crf_number
          ELSE NULL
        END
      ) STORED;
    SQL
  end

  def down
    remove_column :doc_sentences, :clean_case_number
  end
end
