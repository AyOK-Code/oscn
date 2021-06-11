class CreateCaseHtmls < ActiveRecord::Migration[6.0]
  def change
    create_table :case_htmls do |t|
      t.references :court_case, null: false, foreign_key: true
      t.datetime :scraped_at
      t.text :html

      t.timestamps
    end
  end
end
