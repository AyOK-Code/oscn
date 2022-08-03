class Status < ActiveRecord::Migration[6.0]
  def change
    add_reference :doc_statuses, :doc_facility, index: true
  end
end
