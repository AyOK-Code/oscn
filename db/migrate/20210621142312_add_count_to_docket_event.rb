class AddCountToDocketEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :docket_events, :count, :integer
  end
end
