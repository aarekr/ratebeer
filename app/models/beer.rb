class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    summa = 0
    ratings.each{|a| summa += a.score.to_f}
    if ratings.count > 0
      ka = summa / ratings.count
      return "Beer has #{ratings.count} ratings with an average of #{ka}"
    end
  end
end
