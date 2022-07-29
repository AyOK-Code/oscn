class AddNullRestriction < ActiveRecord::Migration[6.0]
  def change
    change_column_null :doc_sentencing_counties, :name, false
  end
end
