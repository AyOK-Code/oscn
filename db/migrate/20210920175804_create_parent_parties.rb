class CreateParentParties < ActiveRecord::Migration[6.0]
  def change
    create_table :parent_parties do |t|
      t.string :name

      t.timestamps
    end
  end
end
