class Customer < ActiveRecord::Base
  validates :first_name, presence: true
  validates :email, presence: true
  validates :password, length: { in: 6..20 }
  has_secure_password
end
