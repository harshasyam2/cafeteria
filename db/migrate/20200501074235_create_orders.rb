class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.date :date
      t.bigint :user_is
      t.integer :bill
    end
  end
end
