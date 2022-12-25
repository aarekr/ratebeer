class Beerclub < ApplicationRecord
  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user

  def to_s
    "{beerclub.name} Beerclub"
  end
end
