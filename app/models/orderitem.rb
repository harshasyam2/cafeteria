class Orderitem < ActiveRecord::Base
  belongs_to :order
  belongs_to :menuitem
  def self.find_by_id(order_id)
    all.where("order_id=?", order_id)
  end

  def self.calculate(x, y)
    x * y
  end

  def self.item_present(orderid)
    all.where("order_id=?", orderid)
  end

  def self.menuitem_present(menuitemid)
    all.where("menuitem_id=?", menuitemid)
  end

  def self.add_items_incart(count, no_of_items)
    count.to_i + no_of_items.to_i
  end
end
