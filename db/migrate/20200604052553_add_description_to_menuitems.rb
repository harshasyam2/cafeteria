class AddDescriptionToMenuitems < ActiveRecord::Migration[6.0]
  def change
    add_column :menuitems, :description, :string
  end
end
