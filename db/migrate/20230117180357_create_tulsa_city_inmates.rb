class CreateTulsaCityInmates < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_city_inmates do |t|
      t.string :inmate_id
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.date :dob
      t.string :height
      t.string :weight
      t.string :hair_color
      t.string :eye_color
      t.string :race
      t.string :gender
      t.date :arrest_date
      t.string :arresting_officer
      t.string :arresting_agency
      t.datetime :booking_date_time
      t.date :court_date
      t.datetime :released_date_time
      t.string :court_division
      t.string :incident_record_id, index: {unique: true}
      t.string :active

      t.timestamps
    end
  end
end
