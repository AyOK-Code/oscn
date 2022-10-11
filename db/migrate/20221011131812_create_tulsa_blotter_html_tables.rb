class CreateTulsaBlotterHtmlTables < ActiveRecord::Migration[6.0]
  def change
    create_table :tulsa_blotter_page_htmls do |t|
      t.integer :page_number, null: false
      t.datetime :scraped_at, null: false
      t.text :html
    end

    create_table :tulsa_blotter_inmate_page_htmls do |t|
      t.references :html, foreign_key: { to_table: :tulsa_blotter_page_htmls }
      t.references :inmate, foreign_key: { to_table: :tulsa_blotter_inmates }
    end

    create_table :tulsa_blotter_inmate_details_htmls do |t|
      t.references :inmate, foreign_key: { to_table: :tulsa_blotter_inmates }
      t.datetime :scraped_at, null: false
      t.text :html
    end
  end
end
