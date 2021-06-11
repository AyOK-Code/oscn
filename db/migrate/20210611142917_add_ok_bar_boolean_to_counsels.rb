class AddOkBarBooleanToCounsels < ActiveRecord::Migration[6.0]
  def change
    add_column :counsels, :ok_bar, :boolean, null: false, default: false
  end
end
