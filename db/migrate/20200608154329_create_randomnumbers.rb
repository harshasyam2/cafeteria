class CreateRandomnumbers < ActiveRecord::Migration[6.0]
  def change
    create_table :randomnumbers do |t|
      t.bigint :otp
    end
  end
end
