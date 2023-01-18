class CreateTulsaCityInmates < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_city_inmates do |t|
      t.string :inmateId
      t.string :firstName
      t.string :middleName
      t.string :lastName
      t.string :DOB
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
      t.string :prisonerID, index: {unique: true}
      t.string :IncidentRecordID, index: {unique: true}
      t.string :active

      t.timestamps
    end
  end
end
