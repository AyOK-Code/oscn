class AddUniqueConstraintsOnTables < ActiveRecord::Migration[6.0]
  def change
    add_index :docket_event_types, :code, unique: true
    add_index :pleas, :name, unique: true
    add_index :verdicts, :name, unique: true
    add_index :counsels, :bar_number, where: 'bar_number IS NOT NULL', unique: true
    add_index :party_types, :name, unique: true
    add_index :parties, :oscn_id, unique: true
  end
end
