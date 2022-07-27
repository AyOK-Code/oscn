class CreateDocSentencingCounties < ActiveRecord::Migration[6.0]
  def change
    create_table :doc_sentencing_counties do |t|
      t.string :name
      t.references :county, null: false, foreign_key: true

      t.timestamps
    end
  end
end
