class RemoveConditionFromMenuitems < ActiveRecord::Migration[6.0]
  def change

    remove_column :menuitems, :condition, :string
  end
end
