require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "Iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "user can create ratings and they are shown on the ratings page" do
    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '8')
    click_button "Create Rating"
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '7')
    click_button "Create Rating"
    visit ratings_path
    expect(page).to have_content("Number of ratings 2")
    expect(page).to have_content("Karhu - Koff 8 Pekka")
    expect(page).to have_content("Iso 3 - Koff 7 Pekka")
  end

  it "user sees only his/her own ratings" do
    visit new_rating_path
    select('Karhu', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '8')
    click_button "Create Rating"
    visit user_path(user)
    click_link('Sign out')
    FactoryBot.create(:user, username: 'Risto', password: 'Secret55', password_confirmation: 'Secret55')
    sign_in(username: "Risto", password: "Secret55")
    visit new_rating_path
    select('Iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '5')
    click_button "Create Rating"
    expect(page).to have_content('Has made 1 rating with an average of 5.0')
    expect(page).to have_content('Iso 3 5')
    expect(page).not_to have_content('Karhu')
    save_and_open_page
  end
end
