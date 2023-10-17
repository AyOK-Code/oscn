class CreateEvictionLetters < ActiveRecord::Migration[7.0]
  def change
    create_table :eviction_letters do |t|
      t.integer :status, default: 0, null: false
      t.references :docket_event_link, null: false, foreign_key: true
      t.string :ocr_plaintiff_address
      t.string :ocr_agreed_amount
      t.string :ocr_default_amount
      t.string :ocr_plaintiff_phone_number
      t.boolean :is_validated, default: false, null: false
      t.string :validation_granularity
      t.string :validation_unconfirmed_components
      t.string :validation_inferred_components
      t.string :validation_usps_address
      t.string :validation_usps_state_zip
      t.float :validation_latitude
      t.float :validation_longitude

      t.timestamps
    end
  end
end
