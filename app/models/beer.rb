class Beer < ApplicationRecord
  include RatingAverage

  validates :name, length: { minimum: 1 }

  belongs_to :brewery, dependent: :destroy
  has_many :ratings, dependent: :destroy
  # has_many :users, through: :ratings
  # has_many :raters, through: :ratings, source: :user
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def to_s
    "#{name} - #{brewery.name}"
  end
end
