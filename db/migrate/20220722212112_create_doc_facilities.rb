class CreateDocFacilities < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_facilities do |t|
      t.string :name
      t.boolean :is_prison, null: false, default: false
      

      t.timestamps
    end
  end
end
