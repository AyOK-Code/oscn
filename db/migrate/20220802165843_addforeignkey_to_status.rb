class AddforeignkeyToStatus < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :doc_statuses, :doc_facilities
  end
end
