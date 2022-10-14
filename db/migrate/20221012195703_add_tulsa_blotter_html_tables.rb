class AddTulsaBlotterHtmlTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_page_htmls do |t|
      t.integer :page_number, null: false
      t.datetime :scraped_at, null: false
      t.text :html
    end

    create_table :tulsa_blotter_arrests_page_htmls do |t|
      t.references :page_html, foreign_key: { to_table: :tulsa_blotter_page_htmls }
      t.references :arrest, foreign_key: { to_table: :tulsa_blotter_arrests }
    end

    create_table :tulsa_blotter_arrest_details_htmls do |t|
      t.references :arrest, foreign_key: { to_table: :tulsa_blotter_arrests }
      t.datetime :scraped_at, null: false
      t.text :html
    end
  end
end
