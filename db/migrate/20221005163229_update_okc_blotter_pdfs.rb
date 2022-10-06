class UpdateOkcBlotterPdfs < ActiveRecord::Migration[6.0]
  def change
    change_column(:okc_blotter_pdfs, :parsed_on, :datetime)
  end
end
