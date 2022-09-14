class CreateRosters < ActiveRecord::Migration[6.0]
  def change
    create_table :rosters do |t|
      t.string :birth_year
      t.string :birth_month
      t.string :birth_day
      t.string :sex
      t.string :race
      t.string :street_address
      t.integer :zip
      t.string :first_name
      t.string :last_name
      t.string :middle_name

      t.timestamps
    end
  end
end
