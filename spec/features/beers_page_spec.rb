require 'rails_helper'

include Helpers

describe "Beers page" do
  it "should contain link 'List of breweries' and NOT contain link 'New beer'" do
    visit beers_path
    expect(page).to have_content("Beers")
    expect(page).not_to have_link("New beer")
    expect(page).to have_link("List of breweries")
  end
end

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "can be created with a valid name" do
    visit beers_path
    click_link('New beer')
    fill_in('beer_name', with: 'Gambrinus')
    select('IPA', from: 'beer[style]')
    expect{
      click_button("Create beer")
    }.to change{Beer.count}.from(0).to(1)
  end

  it "can NOT be created with no name" do
    visit beers_path
    click_link('New beer')
    fill_in('beer_name', with: '')
    select('IPA', from: 'beer[style]')
    click_button "Create beer"
    expect(page).to have_content('error prohibited this beer from being saved')
    expect(page).to have_content('Name is too short')
  end

  it "in database shows on the Beers page" do
    FactoryBot.create(:beer, name: "Staro Brno", brewery:brewery)
    visit beers_path
    expect(page).to have_content("Beers")
    expect(page).to have_content("Staro Brno")
  end
end
