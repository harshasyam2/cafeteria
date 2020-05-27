class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :email
      t.string :city
      t.string :state
      t.bigint :mobile
      t.string :message
    end
  end
end
