class AddforeignkeyToProfile < ActiveRecord::Migration[6.0]
  def change
    add_foreign_key :doc_profiles, :doc_facilities
  end
end
