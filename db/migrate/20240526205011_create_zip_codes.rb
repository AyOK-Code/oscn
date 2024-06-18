class CreateZipCodes < ActiveRecord::Migration[7.0]
  def change
    create_table :zip_codes do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
