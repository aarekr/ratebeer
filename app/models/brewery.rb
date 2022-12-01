class Brewery < ApplicationRecord
  has_many :beers
  has_many :ratings, through: :beers

  def average_rating
    ka_average = ratings.average(:score)

    if ratings.count > 0
      return "Brewey has #{ratings.count} #{"rating".pluralize(ratings.count)} with an average of #{ka_average}"
    end
  end
end
