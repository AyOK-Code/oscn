class AddAdditionalFieldsToCounsel < ActiveRecord::Migration[6.0]
  def change
    add_column :counsels, :first_name, :string
    add_column :counsels, :middle_name, :string
    add_column :counsels, :last_name, :string
    add_column :counsels, :city, :string
    add_column :counsels, :state, :string
    add_column :counsels, :member_type, :string
    add_column :counsels, :member_status, :string
    add_column :counsels, :admit_date, :date
  end
end
