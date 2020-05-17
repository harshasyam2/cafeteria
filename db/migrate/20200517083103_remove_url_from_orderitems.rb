class RemoveUrlFromOrderitems < ActiveRecord::Migration[6.0]
  def change

    remove_column :orderitems, :menuitem_url, :string
  end
end
