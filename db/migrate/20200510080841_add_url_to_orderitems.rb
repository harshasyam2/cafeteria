class AddUrlToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :menuitem_url, :string
  end
end
