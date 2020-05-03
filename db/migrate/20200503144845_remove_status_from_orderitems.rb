class RemoveStatusFromOrderitems < ActiveRecord::Migration[6.0]
  def change

    remove_column :orderitems, :status, :string
  end
end
