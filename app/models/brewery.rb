class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: 2022,
                                   only_integer: true }

  has_many :beers
  has_many :ratings, through: :beers
end
