class AddResolvedAtDateToOcso < ActiveRecord::Migration[6.0]
  def change
    add_column :ocso_warrants, :resolved_at, :datetime
  end
end
