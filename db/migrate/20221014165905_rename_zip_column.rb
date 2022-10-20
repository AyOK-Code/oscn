class RenameZipColumn < ActiveRecord::Migration[6.0]
  def change
    rename_column :tulsa_blotter_arrests, :zip, :city_state_zip
  end
end
