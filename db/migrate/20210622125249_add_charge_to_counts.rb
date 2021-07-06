class AddChargeToCounts < ActiveRecord::Migration[6.0]
  def change
    add_column :counts, :charge, :string
  end
end
