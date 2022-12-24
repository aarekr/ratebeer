class Brewery < ApplicationRecord
  include RatingAverage

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1040,
                                   less_than_or_equal_to: ->(_) { Time.now.year } }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
end
