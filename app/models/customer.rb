class Customer < ActiveRecord::Base
  validates :first_name, presence: true
  validates :email, presence: true
  validates :email, presence: true
  has_secure_password
  has_many :orders

  def self.clerk
    all.where("role=?", "Clerk")
  end

  def self.customer
    all.where("role=?", "Customer")
  end
end
