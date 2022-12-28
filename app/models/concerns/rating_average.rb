module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # return ratings.average(:score).to_f if ratings.count > 0
    rating_count = ratings.size

    return 0 if rating_count == 0

    ratings.map(&:score).sum / rating_count
  end
end
