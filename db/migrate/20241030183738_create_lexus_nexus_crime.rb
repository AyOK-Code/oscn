class CreateLexusNexusCrime < ActiveRecord::Migration[7.0]
  def change
    create_table :community_crimes do |t|
      t.string :address
      t.string :agency
      t.string :crime_class
      t.string :crime
      t.datetime :incident_at
      t.string :incident_number
      t.string :location_type
      t.string :source_data

      t.timestamps

      t.index [:agency, :incident_number, :incident_at], unique: true, name: :index_ln_crimes_on_agency_and_inc_number_and_inc_at
    end
  end
end