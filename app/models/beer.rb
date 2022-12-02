class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def loppuosa
    return "#{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end

  def to_s
    if brewery.nil?
      return "#{name} - no brewery"
    else
      return "#{name} - #{brewery.name}"
    end
  end

end