class Payment < ActiveRecord::Base
  validates :cardnumber, presence: true, numericality: { only_integer: true }, length: { is: 16 }
  validates :cardexpiry, presence: true
  validates :cardholder, presence: true, length: { in: 4..20 }
  validates :cvv, presence: true, length: { is: 3 }
  belongs_to :order
end
