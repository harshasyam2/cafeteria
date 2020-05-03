class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :customer
  def self.incart
    all.where("status=?", "incart")
  end

  def self.currentuser
    all.where(user_id: current_user.id)
  end
end
