class CreateTulsaCityOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_city_offenses do |t|
      t.references :tulsa_city_inmates, foreign_key: true
      t.string :bond
      t.datetime :court_date
      t.string :case_number
      t.string :court_division
      t.string :hold
      t.string :docket_id
      t.string :title
      t.string :section
      t.string :paragraph
      t.string :crime

      t.timestamps
    end
   
  end
end
