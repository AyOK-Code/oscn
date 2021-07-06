class AddDebitCreditToDocketEvent < ActiveRecord::Migration[6.0]
  def change
    add_column :docket_events, :payment, :decimal, default: 0
    add_column :docket_events, :adjustment, :decimal, default: 0
    add_index :docket_events, :amount, where: "amount != 0"
    add_index :docket_events, :payment
    add_index :docket_events, :adjustment
  end
end
