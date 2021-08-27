class AddJudgeToCourtCases < ActiveRecord::Migration[6.0]
  def change
    add_reference :court_cases, :current_judge, foreign_key: { to_table: :judges }
  end
end
