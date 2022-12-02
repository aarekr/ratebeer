class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers
  has_many :ratings, through: :beers

  def loppuosa
    return "#{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end

end