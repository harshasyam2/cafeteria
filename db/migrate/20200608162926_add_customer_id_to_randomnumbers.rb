class AddCustomerIdToRandomnumbers < ActiveRecord::Migration[6.0]
  def change
    add_column :randomnumbers, :customer_id, :bigint
  end
end
