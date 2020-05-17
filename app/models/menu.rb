class Menu < ActiveRecord::Base
  has_many :menuitems
  validates :name, presence: true

  def self.active
    all.where("status=?", "Active")
  end
end
