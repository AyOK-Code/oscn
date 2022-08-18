class AddIsErrorToCourtCases < ActiveRecord::Migration[6.0]
  def change
    add_column :court_cases, :is_error, :boolean, null: false, default: false
  end
end
