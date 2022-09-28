class CreateTulsaBlotterInmates < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_inmates do |t|
      t.string :dlm
      t.string :first
      t.string :middle
      t.string :last
      t.string :gender
      t.references :roster,null: true, foreign_key: true
      t.references :booking,null: true, foreign_key: true
      t.string :race
      t.string :address
      t.string :height
      t.integer :weight
      t.string :zip
      t.string :hair
      t.string :eyes
      t.date :last_scraped_at
      t.string :mugshot

      t.timestamps
    end
  end
end
