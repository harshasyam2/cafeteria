class Order < ActiveRecord::Base
  has_many :order_items
  belongs_to :customer
  def self.incart
    all.where("status=?", "incart")
  end

  def self.user
  end
end
