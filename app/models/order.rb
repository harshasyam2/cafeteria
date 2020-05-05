class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :customer
  def self.incart
    all.where("status=?", "incart")
  end

  def self.ordered
    all.where("status=?", "ordered")
  end

  def self.fromto(initial_date, final_date)
    all.where("date>=? and date<=?", initial_date, final_date)
  end
end
