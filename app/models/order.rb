class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :customer
  def self.incart
    all.where("status=?", "incart")
  end

  def self.ordered
    all.where("status=?", "ordered")
  end

  def self.delivered
    all.where("status=?", "delivered")
  end

  def self.fromto(initial_date, final_date)
    all.where("date>=? and date<=?", initial_date, final_date)
  end

  def self.currentuser(user)
    all.where("customer_id=?", user.id)
  end

  def self.notincart
    all.where("status!=?", "incart")
  end
end
