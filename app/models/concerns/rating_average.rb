module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return ratings.average(:score).to_f if ratings.count > 0
  end
end
