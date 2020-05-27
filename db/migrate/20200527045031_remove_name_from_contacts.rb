class RemoveNameFromContacts < ActiveRecord::Migration[6.0]
  def change

    remove_column :contacts, :name, :string
  end
end
