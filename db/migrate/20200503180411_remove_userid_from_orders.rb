class RemoveUseridFromOrders < ActiveRecord::Migration[6.0]
  def change

    remove_column :orders, :user_id, :bigint
  end
end
