class AddDocProfileIdToParties < ActiveRecord::Migration[6.0]
  def change
    add_reference :parties, :doc_profile, foreign_key: true
  end
end
