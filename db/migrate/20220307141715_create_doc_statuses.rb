class CreateDocStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_statuses do |t|
      t.references :doc_profile, null: false, foreign_key: true
      t.string :facility, null: false
      t.date :date
      t.string :reason

      t.timestamps
    end
  end
end
