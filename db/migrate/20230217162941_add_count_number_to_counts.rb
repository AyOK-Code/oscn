class AddCountNumberToCounts < ActiveRecord::Migration[6.0]
  def change
    add_column :counts, :number, :integer
  end
end
