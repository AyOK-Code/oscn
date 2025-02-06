class UpdateDeathsCountyNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :ok2_explore_deaths, :county_id, true
  end
end
