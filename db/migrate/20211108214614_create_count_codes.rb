class CreateCountCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :count_codes do |t|
      t.string :code, null: false
      t.string :description

      t.timestamps
    end

    add_index :count_codes, :code, unique: true
  end
end
