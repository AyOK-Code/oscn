class UpdateTulsaBlotterColumnTypes < ActiveRecord::Migration[6.0]
  def change
    remove_column :tulsa_blotter_offenses, :bond_amount
    add_column(:tulsa_blotter_offenses, :bond_amount, :decimal,
               precision: 14, scale: 2 )
    remove_column :tulsa_blotter_offenses, :court_date
    add_column(:tulsa_blotter_offenses, :court_date, :date )
  end
end
