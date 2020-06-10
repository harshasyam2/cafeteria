class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.bigint :cardnumber
      t.date :cardexpiry
      t.integer :cvv
    end
  end
end
