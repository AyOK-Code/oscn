class CreateOklahomaStatutes < ActiveRecord::Migration[6.0]
  def change
    create_table :oklahoma_statutes do |t|
      t.string :code
      t.string :ten_digit
      t.string :severity
      t.text :description
      t.date :effective_on
      t.string :update_status

      t.timestamps
    end
  end
end
