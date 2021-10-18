class CreatePartyStats < ActiveRecord::Migration[6.0]
  def change
    create_view :party_stats, materialized: true
    add_index :party_stats, :party_id
  end
end
