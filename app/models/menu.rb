class Menu < ActiveRecord::Base
  has_many :menuitems
  validates :name, presence: true
  validate :menu_title, on: :create

  def menu_not_exists?
    find_name = name.gsub(/\s+/, "").strip.upcase
    menu = Menu.find_by("UPPER(REGEXP_REPLACE(name, '\s', '', 'g'))=?", find_name)
    if menu
      if menu.status == "Active"
        return false
      elsif menu.status == "Inactive"
        return true
      end
    else
      return true
    end
  end

  def self.calculate(x, y)
    x * y
  end

  def menu_title
    unless menu_not_exists?
      errors.add(:menu, "with entered details already exists")
    end
  end

  def self.active
    all.where("status=?", "Active")
  end

  def self.inactive
    all.where("status=?", "Inactive")
  end
end
