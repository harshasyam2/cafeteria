class AddUrlToMenuitems < ActiveRecord::Migration[6.0]
  def change
    add_column :menuitems, :url, :string
  end
end
