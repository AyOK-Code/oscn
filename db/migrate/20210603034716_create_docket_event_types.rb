class CreateDocketEventTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :docket_event_types do |t|
      t.string :code

      t.timestamps
    end
  end
end
