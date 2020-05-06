class Orderitem < ActiveRecord::Base
  belongs_to :order
  #belongs_to :menu_item
  def self.find_by_id(order_id)
    all.where("order_id=?", order_id)
  end

  def self.calculate(x, y)
    x * y
  end
end
