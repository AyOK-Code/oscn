class RemoveUnusedTulsaBlotterColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :tulsa_blotter_arrests, :mugshot, :string
  end
end
