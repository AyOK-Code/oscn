class CreateOkRealEstateAgentPlaces < ActiveRecord::Migration[7.0]
  def change
    create_table :ok_real_estate_agent_places do |t|
      t.references :agent, null: false, foreign_key: { to_table: :ok_real_estate_agents }
      t.references :places, null: false, foreign_key: { to_table: :ok_real_estate_places }

      t.timestamps
    end

    add_index :ok_real_estate_agent_places, [:agent_id, :places_id], unique: true, name: 'index_ok_real_estate_agent_places_on_agent_id_and_places_id'
  end
end
