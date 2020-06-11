class RemoveSoldnumberFromMenuitems < ActiveRecord::Migration[6.0]
  def change

    remove_column :menuitems, :soldnumber, :bigint
  end
end
