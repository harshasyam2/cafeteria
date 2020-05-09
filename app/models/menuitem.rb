class Menuitem < ActiveRecord::Base
  belongs_to :menu
  has_many :orderitems
  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true
end
