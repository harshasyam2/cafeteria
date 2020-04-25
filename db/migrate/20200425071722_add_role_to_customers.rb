class AddRoleToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :role, :string
  end
end
