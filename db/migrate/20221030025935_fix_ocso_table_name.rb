class FixOcsoTableName < ActiveRecord::Migration[6.0]
  def change
    rename_table :osco_warrants, :ocso_warrants
  end
end
