require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Ulla", password: "Ulla1",password_confirmation: "Ulla1" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Rate beer"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "user can create ratings and they are shown on the ratings page" do
    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '8')
    click_button "Rate beer"
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '7')
    click_button "Rate beer"
    visit ratings_path
    expect(page).to have_content("Number of ratings 2")
    expect(page).to have_content("Karhu 8.0")
    expect(page).to have_content("Iso 3 7")
  end

  it "user sees only his/her own ratings on personal page" do
    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '8')
    click_button "Rate beer"
    visit user_path(user)
    click_link('Sign out')
    FactoryBot.create(:user, username: 'Risto', password: 'Secret55', password_confirmation: 'Secret55')
    sign_in(username: "Risto", password: "Secret55")
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '5')
    click_button "Rate beer"
    expect(page).to have_content('Has made 1 rating with an average of 5.0')
    expect(page).to have_content('Iso 3 5')
    expect(page).not_to have_content('Karhu')
  end

  it "ratings in db and their number are shown on ratings page" do
    FactoryBot.create(:rating, beer: beer1, user: user, score: 8)
    FactoryBot.create(:rating, beer: beer2, user: user2)
    visit ratings_path
    expect(page).to have_content('Number of ratings 2')
    expect(page).to have_content('Iso 3 8')
    expect(page).to have_content('Karhu 10')
  end

  it "most active users and recent ratings are displayed" do
    FactoryBot.create(:rating, beer: beer1, user: user, score: 8)
    FactoryBot.create(:rating, beer: beer2, user: user2)
    brewery_wei = FactoryBot.create(:brewery, name: "Weihenstephaner")
    beer_wei = FactoryBot.create(:beer, name: "Hefeweizen", style: "Weizen", brewery:brewery_wei)
    FactoryBot.create(:rating, beer: beer_wei, user: user, score: 15)
    visit ratings_path
    expect(page).to have_content("Most active users")
    expect(page).to have_content("Pekka 2 ratings")
    expect(page).to have_content("Ulla 1 rating")
    expect(page).to have_content("Iso 3 8 202")
    expect(page).to have_content("Hefeweizen 15 202")
    expect(page).to have_content("UTC")
  end

  describe "Personal favorites" do
    let!(:brewery_wei) { FactoryBot.create(:brewery, name: "Weihenstephaner") }
    let!(:beer_wei) { FactoryBot.create(:beer, name: "Hefeweizen", style: "Weizen", brewery:brewery_wei) }
    let!(:rating1) { FactoryBot.create(:rating, beer: beer1, user: user, score: 8) }
    let!(:rating2) { FactoryBot.create(:rating, beer: beer2, user: user, score: 10) }
    let!(:rating3) { FactoryBot.create(:rating, beer: beer_wei, user: user, score: 15) }
    
    it "favorite beer is displayed on the user page" do
      visit user_path(user)
      expect(page).to have_content("Favorite beer: Hefeweizen")
    end

    it "favorite brewery is displayed on the user page" do
      visit user_path(user)
      expect(page).to have_content("Favorite brewery: Koff")
    end

    it "favorite beer style is displayed on the user page" do
      visit user_path(user)
      expect(page).to have_content("Favorite style: Lager")
    end
  end
end
