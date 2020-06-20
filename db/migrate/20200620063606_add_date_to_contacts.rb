class AddDateToContacts < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :date, :date
  end
end
