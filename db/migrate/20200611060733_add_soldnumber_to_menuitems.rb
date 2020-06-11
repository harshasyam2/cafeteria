class AddSoldnumberToMenuitems < ActiveRecord::Migration[6.0]
  def change
    add_column :menuitems, :soldnumber, :bigint
  end
end
