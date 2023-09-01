class AddCleanCaseNumberToDocSentences < ActiveRecord::Migration[7.0]
  def change
    sql = "CASE
    WHEN crf_number ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'
        THEN (
              substring(crf_number, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}') ||
              '-' ||
              (
                  CASE
                      WHEN length(substring(crf_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')) = 2 THEN
                          (
                              CASE
                                  WHEN substring(crf_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')::INT <=
                                       40 THEN
                                          '20' ||
                                          substring(crf_number, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                                  ELSE
                                          '19' ||
                                          substring(crf_number, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                                  END
                              )
                      ELSE
                          substring(crf_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                      END
             )||
             '-' ||
             REGEXP_REPLACE(substring(crf_number, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'), '^0+','')
        )
    END"
    add_column :doc_sentences,
    :clean_case_number,
    :virtual, type: :string, as: sql, stored: true
  
end
end