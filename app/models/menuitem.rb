class Menuitem < ActiveRecord::Base
  belongs_to :menu
  has_many :orderitems
  validates :name, presence: true
  validates :price, presence: true, numericality: { only_integer: true }
  validates :url, presence: true
  validate :menuitem_title, on: :create

  def menuitem_not_exists?
    find_name = name.gsub(/\s+/, "").strip.upcase
    menuitem = Menuitem.find_by("UPPER(REGEXP_REPLACE(name, '\s', '', 'g'))=?", find_name)
    if menuitem
      return false
    else
      return true
    end
  end

  def menuitem_title
    unless menuitem_not_exists?
      errors.add(:menuitem, "with entered details already exists")
    end
  end

  def self.menuitem_with_id(menu_id)
    all.where("menu_id=?", menu_id)
  end

  def self.active
    all.where("status=?", "Active")
  end

  def self.menu_present(menu_id)
    all.where("menu_id=?", menu_id)
  end

  def self.sold
    all.where("condition=?", "sold")
  end
end
