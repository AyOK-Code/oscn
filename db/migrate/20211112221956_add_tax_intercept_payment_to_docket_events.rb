class AddTaxInterceptPaymentToDocketEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :docket_events, :is_otc_payment, :boolean, null: false, default: false
  end
end
