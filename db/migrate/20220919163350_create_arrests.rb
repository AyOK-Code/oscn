class CreateArrests < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_arrests do |t|
      t.references :tulsa_blotter_inmates, null: true, foreign_key: true
      t.string :arrest_date
      t.string :arrest_time
      t.string :arrested_by
      t.string :booking_date
      t.string :booking_time
      t.string :release_date
      t.string :release_time

      t.timestamps
    end
  end
end
