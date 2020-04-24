class RemovecategotyFromMenus < ActiveRecord::Migration[6.0]
  def change
    remove_column :menus, :categoty
  end
end
