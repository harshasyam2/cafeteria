class AddConditionToMenuitems < ActiveRecord::Migration[6.0]
  def change
    add_column :menuitems, :condition, :string
  end
end
