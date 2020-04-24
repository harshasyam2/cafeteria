class Menu < ActiveRecord::Base
  has_many :menuitems
  validates :name, presence: true
  validates :category, presence: true
end
