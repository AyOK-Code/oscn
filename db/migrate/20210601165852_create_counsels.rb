class CreateCounsels < ActiveRecord::Migration[6.0]
  def change
    create_table :counsels do |t|
      t.string :name
      t.string :address
      t.integer :bar_number

      t.timestamps
    end
  end
end
