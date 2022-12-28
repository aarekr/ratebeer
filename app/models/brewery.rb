class Brewery < ApplicationRecord
  include RatingAverage

  def year_not_greater_than_this_year
    errors.add(:year, "can't be greater than current year") if year > Time.now.year
  end

  validates :name, length: { minimum: 1 }
  validates :year, numericality: { only_integer: true,
                                   greater_than_or_equal_to: 1040 }
  validate :year_not_greater_than_this_year

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }
end
