class CreateArrests < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_arrests do |t|
      t.references :tulsa_blotter_inmates, null: true, foreign_key: true
      t.datetime :arrest_date
      t.string :arrested_by
      t.string :arresting_agency
      t.datetime :booking_date
      t.datetime :release_date
      t.date :freedom_date

      t.timestamps
    end
  end
end
