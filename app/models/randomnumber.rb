class Randomnumber < ActiveRecord::Base
  belongs_to :customer

  def self.current_user(user)
    all.where("customer_id=?", user.id)
  end
end
