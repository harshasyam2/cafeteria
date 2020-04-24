class RemovecategoryFromMenus < ActiveRecord::Migration[6.0]
  def change
    remove_column :menus, :category
  end
end
