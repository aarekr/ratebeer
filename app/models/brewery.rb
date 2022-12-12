class Brewery < ApplicationRecord
  include RatingAverage

  def vuosi_check
    vuosi_nyt = Time.now.year
    return errors.add(:year, "can't be in the future") if year > vuosi_nyt
  end

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040 }
  validate :vuosi_check
  validates :year, numericality: { only_integer: true }

  has_many :beers
  has_many :ratings, through: :beers
end
