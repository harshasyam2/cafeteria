class Customer < ActiveRecord::Base
  validates :first_name, presence: true
  validates :email, presence: true
  validates :contact_number, presence: true, numericality: { only_integer: true }, length: { minimum: 10 }
  validates :password, length: { minimum: 4, maximum: 9 }, on: :create
  has_secure_password
  has_many :orders

  def notcustomer?
    role != "Customer"
  end

  def self.clerk
    all.where("role=?", "Clerk")
  end

  def self.customer
    all.where("role=?", "Customer")
  end
end
