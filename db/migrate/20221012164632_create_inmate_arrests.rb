class CreateInmateArrests < ActiveRecord::Migration[6.0]
  def change
    drop_table :tulsa_blotter_offenses
    drop_table :tulsa_blotter_arrests
    drop_table :tulsa_blotter_inmates

    create_table :tulsa_blotter_arrests do |t|
      t.string :dlm
      t.string :first
      t.string :middle
      t.string :last
      t.string :gender
      t.references :roster,null: true, foreign_key: true
      t.string :booking_id,null: false
      t.string :race
      t.string :address
      t.string :height
      t.integer :weight
      t.string :zip
      t.string :hair
      t.string :eyes
      t.date :last_scraped_at
      t.string :mugshot

     
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
