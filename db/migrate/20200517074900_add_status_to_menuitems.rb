class AddStatusToMenuitems < ActiveRecord::Migration[6.0]
  def change
    add_column :menuitems, :status, :string
  end
end
