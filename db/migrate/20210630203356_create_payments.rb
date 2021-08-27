class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_view :payments
  end
end
