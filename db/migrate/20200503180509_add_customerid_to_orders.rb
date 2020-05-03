class AddCustomeridToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :customer_id, :bigint
  end
end
