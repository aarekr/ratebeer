class Beer < ApplicationRecord
  belongs_to :brewery, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def average_rating
    #summa = 0
    #ratings.each{|a| summa += a.score.to_f}     # .each
    #summa_map_sumilla = ratings.map{|a| a.score.to_f}.sum
    #summa_reducella = ratings.map{|a| a.score.to_f}.reduce{|sum,a| sum+a}

    ka_average = ratings.average(:score)

    if ratings.count > 0
      #ka = summa_map_sumilla / ratings.count
      return "Beer has #{ratings.count} #{"rating".pluralize(ratings.count)} with an average of #{ka_average}"
    end
  end

  def to_s
    if brewery.nil?
      return "#{name} - no brewery"
    else
      return "#{name} - #{brewery.name}"
    end
  end
end
