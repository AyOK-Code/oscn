class ChangeForeignKeyForTulsaCityOffense < ActiveRecord::Migration[6.0]
  def change
    rename_column :tulsa_city_offenses, :tulsa_city_inmates_id, :inmate_id
  end
end
