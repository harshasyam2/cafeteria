class Menuitem < ActiveRecord::Base
  belongs_to :menu
  has_many :orderitems
  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true
  def self.menuitem_with_id(menu_id)
    all.where("menu_id=?", menu_id)
  end
end
