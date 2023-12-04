class CreateStructureFireLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :structure_fire_links do |t|
      t.string :url
      t.date :date

      t.timestamps
    end
  end
end
