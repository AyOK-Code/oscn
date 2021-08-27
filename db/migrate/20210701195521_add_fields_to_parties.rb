class AddFieldsToParties < ActiveRecord::Migration[6.0]
  def change
    add_column :parties, :first_name, :string
    add_column :parties, :middle_name, :string
    add_column :parties, :last_name, :string
    add_column :parties, :birth_month, :integer, precision: 2
    add_column :parties, :birth_year, :integer, precision: 4
  end
end
