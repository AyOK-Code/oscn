class AddEnqueueToCourtCases < ActiveRecord::Migration[6.0]
  def change
    add_column :court_cases, :enqueued, :boolean, null:false, default:false
  end
end
