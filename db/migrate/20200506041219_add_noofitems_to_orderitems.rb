class AddNoofitemsToOrderitems < ActiveRecord::Migration[6.0]
  def change
    add_column :orderitems, :no_of_items, :integer
  end
end
