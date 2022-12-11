class Membership < ApplicationRecord
  belongs_to :beerclub
  belongs_to :user

  def to_s
    "#{beerclub} Membership"
  end
end
