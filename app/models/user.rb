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

  def style_kasittely(userit, reittaukset, suosikki_tyyli_taulu)
    userit.each do |user|
      data = {}
      suosikki_tyyli = ""; suosikki_lkm = 0
      reittaukset.each do |r|
        if r.user_id == user.id
          data[r.beer.style] = data[r.beer.style].to_i + r.score.to_i
          if data[r.beer.style] > suosikki_lkm
            suosikki_lkm = data[r.beer.style]
            suosikki_tyyli = r.beer.style
          end
        end
      end
      suosikki_tyyli_taulu[user.id] = suosikki_tyyli
    end
    suosikki_tyyli_taulu
  end

  def favorite_style
    suosikki_tyyli_taulu = {}
    userit = User.all
    reittaukset = Rating.all
    style_kasittely(userit, reittaukset, suosikki_tyyli_taulu)
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
