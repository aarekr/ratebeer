class Beerclub < ApplicationRecord
  belongs_to :user

  has_many :users # has_many :members, source: :user

  def to_s
    "{beerclub.name} Beerclub"
  end
end
