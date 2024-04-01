class CreateStructureFireLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :structure_fire_links do |t|
      t.string :url , null: false
      t.date :pdf_date_on , null: false

      t.timestamps
    end
  end
end
