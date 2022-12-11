class User < ApplicationRecord
  include RatingAverage

  def check_capital_letter
    if not password =~ /[A-Z]/
      errors.add(:password, "should contain at least 1 capital letter")
    end
  end

  def check_number
    if not password =~ /[0-9]/
      errors.add(:password, "should contain at least 1 number")
    end
  end

  has_secure_password

  validates :username, uniqueness: true
  validates :username, length: { minimum: 3, maximum: 30 }

  validates :password, length: { minimum: 4 }
  validate :check_capital_letter
  validate :check_number

  has_many :ratings
  has_many :beers, through: :ratings
  has_many :beerclubs
end
