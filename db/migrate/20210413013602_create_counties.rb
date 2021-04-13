class CreateCounties < ActiveRecord::Migration[6.0]
  def change
    create_table :counties do |t|
      t.string :name, null: false
      t.string :fips_code, null: false

      t.timestamps
    end
  end
end
