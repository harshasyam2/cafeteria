class AddContactToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :contact_number, :bigint
  end
end
