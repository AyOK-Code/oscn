class UpdateFieldNameOfStructureFireLinks < ActiveRecord::Migration[7.0]
  def change
    rename_column :structure_fire_links, :url, :external_url
  end
end
