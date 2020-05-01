class Customer < ActiveRecord::Base
  validates :first_name, presence: true
  validates :email, presence: true
  validates :email, presence: true
  has_secure_password

  def clerk
    all.where("role=?", "Clerk")
  end

  def customer
    all.where("role=?", "Customer")
  end
end
