class UpdateFiledByToString < ActiveRecord::Migration[7.0]
  def change
    remove_reference :issues, :filed_by, index: true, foreign_key: { to_table: :parties }
    add_column :issues, :filed_by, :string
  end
end
