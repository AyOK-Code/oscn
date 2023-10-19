class ChangeVerdictNullonIssueParties < ActiveRecord::Migration[7.0]
  def change
    change_column_null :issue_parties, :verdict_id, true
  end
end
