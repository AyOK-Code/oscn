class FixBondAmount < ActiveRecord::Migration[6.0]
  def change
    rename_column :tulsa_blotter_offenses, :bound_amount, :bond_amount
  end
end
