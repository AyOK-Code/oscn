class CreateTulsaCityInmates < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_city_inmates do |t|
      t.string :inmateId
      t.string :firstName
      t.string :middleName
      t.string :lastName
      t.string :dob
      t.string :height
      t.string :weight
      t.string :hairColor
      t.string :eyeColor
      t.string :race
      t.string :gender
      t.string :arrestDate
      t.string :arrestingOfficer
      t.string :arrestingAgency
      t.string :bookingDateTime
      t.string :courtDate
      t.string :releasedDateTime
      t.string :courtDivision
      t.string :incidentRecordID, index: {unique: true}
      t.string :active

      t.timestamps
    end
  end
end
