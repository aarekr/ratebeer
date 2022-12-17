class User < ApplicationRecord
  include RatingAverage

  def check_capital_letter
    return errors.add(:password, "should contain at least 1 capital letter") if password !~ /[A-Z]/
  end

  def check_number
    return errors.add(:password, "should contain at least 1 number") if password !~ /[0-9]/
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.order(score: :desc).limit(1).first.beer
  end

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 }
  validate :check_capital_letter
  validate :check_number

  has_many :ratings
  has_many :beers, through: :ratings

  has_many :beerclubs, through: :memberships
end
