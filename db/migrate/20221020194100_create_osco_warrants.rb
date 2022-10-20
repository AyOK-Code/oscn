class CreateOscoWarrants < ActiveRecord::Migration[6.0]
  def change
    create_table :osco_warrants do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth_date
      t.string :case_number
      t.decimal :bound_amount
      t.date :issued
      t.string :counts

      t.timestamps
    end
  end
end
