class AddCodeToCount < ActiveRecord::Migration[6.0]
  def change
    add_column :counts, :filed_statute_code, :string
    add_column :counts, :disposed_statute_code, :string
  end
end
