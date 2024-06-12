class AddCleanCaseNumberToCourtCases < ActiveRecord::Migration[7.0]

  def change
    add_column :court_cases,
               :clean_case_number,
               :virtual, type: :string, as: get_case_number_sql("case_number"), stored: true
    add_column :tulsa_city_offenses,
               :clean_case_number,
               :virtual, type: :string, as: get_case_number_sql("case_number"), stored: true
    add_column :tulsa_blotter_offenses,
               :clean_case_number,
               :virtual, type: :string, as: get_case_number_sql("case_number"), stored: true
    add_column :doc_sentences,
               :clean_case_number,
               :virtual, type: :string, as: get_case_number_sql("crf_number"), stored: true
  end

  def get_case_number_sql(column_name)
    sql = <<-SQL
      select CASE
                 WHEN case_number::text ~ '^([A-Za-z]{2,3})?-?[0-9]{2,4}-[0-9]{2,8}'
                     THEN
                     (
                         (
                                         (
                                             (CASE
                                                  WHEN case_number ~ '^[A-Za-z]{2,3}'
                                                      THEN
                                                      substring((case_number), '^([A-Za-z]{2,3})')
                                                  ELSE
                                                      'CF'
                                                 END
                                                 )::text
                                             )
                                         ||
                                         '-'::text
                                     ||
                                         (CASE
                                              WHEN (length(substring(case_number, '([0-9]{2,4})-')) = 2)
                                                  THEN
                                                  (
                                                      CASE
                                                          WHEN substring(case_number, '([0-9]{2,4})-')::integer <= 40
                                                              THEN '20' || substring(case_number, '([0-9]{2,4})-')
                                                          ELSE '19' || substring(case_number, '([0-9]{2,4})-')
                                                          END)
                                              ELSE
                                                  "substring"((case_number), '([0-9]{2,4})-')
                                             END
                                             ) || '-'
                             ) ||
                         regexp_replace("substring"(case_number, '-([0-9]{2,8})$'), '^0+', '')
                     )
                 ELSE NULL::text
                 END
      from (select unnest(array ['CM-2022-00029', '42-00029','CM2022-00029']) as case_number) as main;
    SQL
    sql.gsub("case_number", column_name)
  end
end
