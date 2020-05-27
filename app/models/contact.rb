class Contact < ActiveRecord::Base
  validates :first_name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :email, presence: true
  validates :mobile, presence: true, numericality: { only_integer: true }, length: { minimum: 10 }
  validates :message, presence: true
end
