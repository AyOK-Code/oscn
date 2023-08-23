class AddCleanCaseNumberToCourtCases < ActiveRecord::Migration[7.0]
  def change
    sql = "CASE
    WHEN case_number ~ '^[A-Za-z]{2,3}-?[0-9]{2,4}-[0-9]{2,8}'
        THEN (
              substring(case_number, '^([A-Za-z]{2,3})-?[0-9]{2,4}-[0-9]{2,8}') ||
              '-' ||
              (
                  CASE
                      WHEN length(substring(case_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')) = 2 THEN
                          (
                              CASE
                                  WHEN substring(case_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')::INT <=
                                       40 THEN
                                          '20' ||
                                          substring(case_number, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                                  ELSE
                                          '19' ||
                                          substring(case_number, '[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                                  END
                              )
                      ELSE
                          substring(case_number, '^[A-Za-z]{2,3}-?([0-9]{2,4})-[0-9]{2,8}')
                      END
             )||
             '-' ||
             REGEXP_REPLACE(substring(case_number, '^[A-Za-z]{2,3}-?[0-9]{2,4}-([0-9]{2,8})'), '^0+','')
        )
    END"
   
  
  end
end
