class CreateOkcBlotterPdfs < ActiveRecord::Migration[6.0]
  def change
    create_table :okc_blotter_pdfs do |t|
      t.date :parsed_on
      t.date :date

      t.timestamps
    end
  end
end
