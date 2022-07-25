class Profile < ActiveRecord::Migration[6.0]
  def change
    add_reference :doc_profiles, :doc_facility, index: true
  end
end
