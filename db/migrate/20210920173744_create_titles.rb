class CreateTitles < ActiveRecord::Migration[6.0]
  def change
    create_table :titles do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
