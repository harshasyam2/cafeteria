class Order < ActiveRecord::Base
  has_many :orderitems
  belongs_to :customer
  validates :address, presence: true, on: :update, length: { minimum: 10 }

  def self.incart
    all.where("status=?", "incart")
  end

  def self.ordered
    all.where("status=?", "ordered")
  end

  def self.cancelled
    all.where("status=?", "cancelled")
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
