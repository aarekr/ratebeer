class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, dependent: :destroy
  has_many :ratings, dependent: :destroy

  def to_s
    "#{name} - #{brewery.name}"
  end
end
