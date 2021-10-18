class AddSuffixToParties < ActiveRecord::Migration[6.0]
  def change
    add_column :parties, :suffix, :string
  end
end
