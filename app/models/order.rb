class Order < ActiveRecord::Base
  belongs_to :customer
  has_many :orderitems
  has_one :payments
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

  def self.customername(cust_name)
    all.where("UPPER(REGEXP_REPLACE(customer_name, '\s', '', 'g')) like ?", "%#{cust_name}%")
  end
end
