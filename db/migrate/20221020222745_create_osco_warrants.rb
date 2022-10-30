class CreateOcsoWarrants < ActiveRecord::Migration[6.0]
  def change
  
    create_table :osco_warrants do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth_date
      t.string :case_number
      t.decimal :bond_amount, precision: 14, scale: 2 
      t.date :issued
      t.string :counts

      t.timestamps
    end

    add_index :osco_warrants,
              [:case_number, :first_name, :last_name, :birth_date],
              unique: true,
              name: "index_ocso_warrants_on_case_number_etc"
  end
end
