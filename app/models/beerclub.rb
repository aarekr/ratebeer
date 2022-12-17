class Beerclub < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  def to_s
    "{beerclub.name} Beerclub"
  end
end
