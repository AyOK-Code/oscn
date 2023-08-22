class AddCleanCaseNumberToCaseNotFounds < ActiveRecord::Migration[7.0]
  def change
    sql = "CASE WHEN case_number ~ '^[A-Za-z]{2}[0-9]{5,}' THEN (SUBSTRING(case_number, 1, 2) || '-' || (
      CASE WHEN SUBSTRING(case_number, 3, 2)::INT <= 23 THEN
        '20' || SUBSTRING(case_number, 3, 2)
      ELSE
        '19' || SUBSTRING(case_number, 3, 2)
      END) || '-' || REGEXP_REPLACE(SUBSTRING(case_number, 5), '^0+', ''))
     WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{2}-[0-9]{1,}' THEN
       SUBSTRING(case_number, 1, 2) || '-' || (
        CASE WHEN SPLIT_PART(case_number, '-', 2)::INT <= 23 THEN
          '20' || SPLIT_PART(case_number, '-', 2)
        ELSE
          '19' || SPLIT_PART(case_number, '-', 2)
        END) || '-' || SPLIT_PART(case_number, '-', 3)
     WHEN case_number ~ '^[A-Za-z]{2}-[0-9]{4}-[0-9]{1,}' THEN case_number
    ELSE NULL END"
   
   add_column :case_not_founds,
     :clean_case_number,
     :virtual, type: :string, as: sql, stored: true
  end
end
