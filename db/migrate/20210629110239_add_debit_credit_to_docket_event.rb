class AddDebitCreditToDocketEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :docket_events, :payment, :decimal, default: 0, null: false
    add_column :docket_events, :adjustment, :decimal, default: 0, null: false
    add_index :docket_events, :amount, where: "amount != 0"
  end
end
