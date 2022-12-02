module RatingAverage
    extend ActiveSupport::Concern
   
    def average_rating
        if ratings.count > 0
            return ratings.average(:score)
        end
    end
end