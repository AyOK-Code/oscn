class RenameCaseToCourtCase < ActiveRecord::Migration[6.0]
  def change
    rename_table :cases, :court_cases
    rename_column :case_parties, :case_id, :court_case_id
    rename_column :counsel_parties, :case_id, :court_case_id
    rename_column :counts, :case_id, :court_case_id
    rename_column :docket_events, :case_id, :court_case_id
    rename_column :events, :case_id, :court_case_id
  end
end
