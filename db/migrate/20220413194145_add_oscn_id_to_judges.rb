class AddOscnIdToJudges < ActiveRecord::Migration[6.0]
  def change
    add_column :judges, :oscn_id, :integer, null: false
    add_column :judges, :first_name, :string
    add_column :judges, :last_name, :string
    change_column_null :judges, :county_id, true
  end
end
