class Orderitem < ActiveRecord::Base
  def self.incart
    all.where("status=?", "incart")
  end
end
