class CreateTulsaCityOffenses < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_city_offenses do |t|
      t.references :tulsa_city_inmates, foreign_key: true
      t.string :bond
      t.string :courtDate
      t.string :caseNumber
      t.string :courtDivision
      t.string :hold
      t.string :docketId, index: {unique: true}
      t.string :title
      t.string :section
      t.string :paragraph
      t.string :crime

      t.timestamps
    end
  end
end
