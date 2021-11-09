class AddIdCodeIndexToDocketEventTypes < ActiveRecord::Migration[6.0]
  def change
    add_index :docket_event_types, [:id, :code]
  end
end
