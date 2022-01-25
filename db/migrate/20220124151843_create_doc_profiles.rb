class CreateDocProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_profiles do |t|
      t.integer :doc_number, null: false
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :suffix
      t.date :last_move_date
      t.string :facility
      t.date :birth_date
      t.integer :sex
      t.string :race
      t.string :hair
      t.string :height_ft
      t.string :height_in
      t.string :weight
      t.string :eye
      t.integer :status

      t.timestamps
    end
  end
end
