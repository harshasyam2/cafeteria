class Contact < ActiveRecord::Base
  validates :last_name, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :email, presence: true
  validates :mobile, presence: true
  validates :message, presence: true
end
