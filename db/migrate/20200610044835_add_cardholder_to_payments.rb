class AddCardholderToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :cardholder, :string
    add_column :payments, :order_id, :bigint
  end
end
