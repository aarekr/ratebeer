require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"
    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"
    #expect(user.valid?).to be(false)
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a short password" do
    user = User.create username: "Bertta", password: "Ab2", password_confirmation: "Ab2"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved with a password that contains only small letters" do
    user = User.create username: "Bertta", password: "abcde", password_confirmation: "abcde"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }
  
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end
  
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only beer rated if only one rating given" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)
      expect(user.favorite_beer).to eq('anonymous')
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating({ user: user }, 10 )
      create_beer_with_rating({ user: user }, 7 )
      # create_beers_with_many_ratings( {user: user}, 10, 15, 9) # 3 olutta kerralla
      paras = FactoryBot.create(:beer, name: 'Gambrinus')
      FactoryBot.create(:rating, beer: paras, score: 25, user: user )
      expect(user.favorite_beer).to eq('Gambrinus')
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "with two beers, favorite style is returned" do
      beer1 = FactoryBot.create(:beer, name: 'Punk IPA', style: 'IPA')
      beer2 = FactoryBot.create(:beer, name: 'Gambrinus', style: 'Lager')
      rating = FactoryBot.create(:rating, score: 5, beer: beer1, user: user)
      rating = FactoryBot.create(:rating, score: 9, beer: beer2, user: user)
      expect(user.favorite_style).to eq(1=>"Lager")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "with two breweries, favorite brewery is returned" do
      brewery1 = FactoryBot.create(:brewery, name: "Koff")
      brewery2 = FactoryBot.create(:brewery, name: "Karjala")
      beer1 = FactoryBot.create(:beer, brewery: brewery1)
      beer2 = FactoryBot.create(:beer, brewery: brewery2)
      rating = FactoryBot.create(:rating, score: 5, beer: beer1, user: user)
      rating = FactoryBot.create(:rating, score: 9, beer: beer2, user: user)
      expect(user.favorite_brewery).to eq(1=>"Karjala")
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user] )
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end
