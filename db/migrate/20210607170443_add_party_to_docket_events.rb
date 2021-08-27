class AddPartyToDocketEvents < ActiveRecord::Migration[6.0]
  def change
    add_reference :docket_events, :party, foreign_key: true
  end
end
